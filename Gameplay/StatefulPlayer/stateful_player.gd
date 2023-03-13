extends KinematicBody2D
class_name Player

var velocity = Vector2.ZERO
var right_top_cast: RayCast2D
var right_bottom_cast: RayCast2D
var left_top_cast: RayCast2D
var left_bottom_cast: RayCast2D

var horizontal_speed = 0.0

var health: int = 100
var powers: int = 0

var player_cam: Camera2D

func _ready():
	add_to_group("Player")
	connect_signals()
	set_default_casts()
	player_cam = $Camera2D
	
func set_default_casts(initialize=true):
	if initialize:
		initialize_casts()
	setup_casts(
		{
			right_top_cast: Vector2(12, -8),
			right_bottom_cast: Vector2(12, 6), 
			left_top_cast: Vector2(-12, -8), 
			left_bottom_cast: Vector2(-12, 6)
		}
	)

func connect_signals():
	$StateMachine.connect("transitioned", self, "_stateMachine_transitioned")
	
func initialize_casts():
	right_top_cast = RayCast2D.new()
	right_bottom_cast = RayCast2D.new()
	left_top_cast = RayCast2D.new()
	left_bottom_cast = RayCast2D.new()

func setup_casts(casts):
	for cast in casts:
		add_child(cast)
		cast.collision_mask = 2
		cast.cast_to = casts[cast]
		cast.enabled = true	

func _stateMachine_transitioned(new_name):
#	print(new_name)
	pass

func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.is_pressed():
		match event.scancode:
			KEY_1:
				evolve(1)
			KEY_2:
				evolve(1 << 1)
			KEY_3:
				evolve(1 << 2)
			KEY_4:
				evolve(1 << 3)
			KEY_5:
				evolve(1 << 4)
			KEY_6:
				evolve(1 << 5)
			KEY_7:
				evolve(1 << 6)
			KEY_8:
				evolve(1 << 7)
			KEY_0:
				evolve(1)
				evolve(2)
				evolve(3)
				evolve(4)
				evolve(8)
				evolve(16)
				evolve(32)
				evolve(64)
			_:
				pass

func _physics_process(delta):
	velocity = move_and_slide_with_snap(velocity.limit_length(325), Vector2.UP, Vector2.UP)
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x < 0

func get_wall() -> int:
	if right_top_cast.is_colliding() || right_bottom_cast.is_colliding():
		return 1
	if left_top_cast.is_colliding() || left_bottom_cast.is_colliding():
		return -1
	return 0
	
func evolve(pickup_value: int = 0) -> void:
	print("evolving " + str(pickup_value))
	if not powers & pickup_value:
		powers += pickup_value
		EventBus.emit_signal("powerup", pickup_value)
		print("got new power!")
	pass

func is_squeezable():
	if not is_on_wall() or not can_shrink():
		return
	var wall = get_wall()
	var output = false
	if wall == 1:
		right_top_cast.cast_to = Vector2(12, 8);
		right_top_cast.force_raycast_update()
		output = not right_top_cast.is_colliding()
	elif wall == -1:
		left_top_cast.cast_to = Vector2(-12, 8)
		left_top_cast.force_raycast_update()
		output =  not left_top_cast.is_colliding()
	set_default_casts(false)
	print("" if output else "not" + " squeezable")
	return output

func die():
	print("im dead")

func shrink_collider():
	$CollisionShape2D.scale = Vector2(1, 0.5)
	$Sprite.scale = Vector2(0.2, 0.1)
	setup_casts(
		{
			right_top_cast: Vector2(8, -6),
			right_bottom_cast: Vector2(8, 6), 
			left_top_cast: Vector2(-8, -6), 
			left_bottom_cast: Vector2(-8, 6)
		}
	)
	pass

func take_damage(damage: int, damage_source: Vector2, stun_strength = 1):
	if health - damage > 0:
		health -= damage
		$StateMachine.transition_to("hitstun", {
			"direction" : (global_position - damage_source).normalized() * stun_strength,
			"stun_time": 0.125
		})
		print(str(health) + " going to hitstun")
	else:
		die()
	
func unshrink_collider():
	$CollisionShape2D.scale = Vector2(1, 1)
	$Sprite.scale = Vector2(0.275, 0.275)
	set_default_casts(false)
	pass

func set_animation(animation_name: String):
	$AnimationPlayer.play(animation_name)

func can_run() -> bool:
	return Global.POWERUP_TYPE.RUN & powers
	
func can_jump() -> bool:
	return Global.POWERUP_TYPE.JUMP & powers
	
func can_wall_jump() -> bool:
	return Global.POWERUP_TYPE.WALLJUMP & powers
	
func can_dash() -> bool:
	return Global.POWERUP_TYPE.DASH & powers

func can_double_jump() -> bool:
	return Global.POWERUP_TYPE.DOUBLEJUMP & powers
	
func can_shrink() -> bool:
	return Global.POWERUP_TYPE.SHRINK & powers

func can_unshrink() -> bool:
	return (Global.POWERUP_TYPE.SHRINK & powers) and (!left_top_cast.is_colliding() and !right_top_cast.is_colliding())

func restore_follow_cam(current_camera: Camera2D):
	pass
