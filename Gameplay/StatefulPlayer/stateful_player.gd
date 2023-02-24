extends KinematicBody2D

var velocity = Vector2.ZERO
var right_cast: RayCast2D
var left_cast: RayCast2D

var powers: int = 0

func _ready():
	connect_signals()
	setup_casts()
	
func connect_signals():
	$StateMachine.connect("transitioned", self, "_stateMachine_transitioned")
	
func setup_casts():
	right_cast = RayCast2D.new()
	left_cast = RayCast2D.new()
	add_child(right_cast)
	add_child(left_cast)
	right_cast.collision_mask = 2
	left_cast.collision_mask = 2
	right_cast.cast_to = Vector2(12, 0)
	left_cast.cast_to = Vector2(-12, 0)
	right_cast.enabled = true
	left_cast.enabled = true

func _stateMachine_transitioned(new_name):
	print(new_name)

func _physics_process(delta):
	velocity = move_and_slide_with_snap(velocity.limit_length(325), Vector2.UP, Vector2.UP)

func get_wall() -> int:
	if right_cast.is_colliding():
		return 1
	if left_cast.is_colliding():
		return -1
	return 0
	
func evolve(pickup_value: int = 0) -> void:
	print("evolving " + str(pickup_value))
	var power_of_2 = sqrt(pickup_value)
	if not powers & pickup_value:
		powers += pickup_value
		EventBus.emit_signal("powerup", pickup_value)
		print("got new power!")
	pass

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
