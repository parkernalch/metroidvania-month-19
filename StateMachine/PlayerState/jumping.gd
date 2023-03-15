extends State
	
var state_machine: StateMachine
export var jump_force: float = 200
var direction = 0
var jumps_remaining = 0
var control_lock_time = 0
var time_since_jump = 0
var wall = 0
var jump_type = ""

var jump_sound = preload("res://Assets/sounds/jump.wav")
onready var audio_player = owner.get_node("AudioStreamPlayer2D")

func handle_input(input: InputEvent) -> void:
	if input.is_action_released("jump") and owner.can_double_jump():
		state_machine.transition_to("falling", { "jumps_remaining": jumps_remaining })
	if input.is_action_pressed("dash") and jumps_remaining > 0 and owner.can_dash():
		state_machine.transition_to("dashing", {
			"jumps_remaining": jumps_remaining - 1,
			"direction": Vector2(direction, 0)
		})
	pass

func update(delta: float) -> void:
	direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
func physics_update(delta: float) -> void:
	if control_lock_time > 0:
		control_lock_time -= delta
		owner.velocity = Vector2(owner.velocity.x + direction * owner.horizontal_speed * (0.25 - control_lock_time), owner.velocity.y)		
	else:	
		owner.velocity = Vector2(direction * owner.horizontal_speed, owner.velocity.y)
	owner.velocity += Vector2.DOWN * 9.8
	if owner.velocity.y > 0:
		state_machine.transition_to("falling", { "jumps_remaining": jumps_remaining })
	time_since_jump += delta
	if time_since_jump <= 0.12:
		if direction * wall < 0 and jump_type == "high":
			owner.velocity = evaluate_launch_vector(direction, wall) * jump_force
		elif direction * wall > 0 and jump_type == "long":
			owner.velocity = evaluate_launch_vector(direction, wall) * jump_force
		else:
			pass
	
func evaluate_launch_vector(direction: float, wall: int) -> Vector2:
	if wall == 0:
		return Vector2.UP
	else:
		var diagonal = Vector2.ZERO
		if wall * direction > 0:
			# jump high
			diagonal = Vector2.UP * 2 + Vector2.RIGHT * -sign(wall)
			jump_type = "high"
		elif wall * direction < 0:
			# jump far
			diagonal = Vector2.UP + Vector2.RIGHT * 2 * -sign(wall)
			jump_type = "long"
		else:
			diagonal = Vector2.ZERO
		return diagonal.normalized() * 1.5
	return Vector2.ZERO
	
func enter(_msg := {}) -> void:
	owner.set_animation("jump")
	audio_player.stream = jump_sound
	audio_player.play()
	direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	jumps_remaining = _msg.jumps_remaining if _msg.has("jumps_remaining") else 0
	control_lock_time = _msg.control_lock_time if _msg.has("control_lock_time") else 0
	wall = _msg.last_wall if _msg.has("last_wall") else 0
	var jump_vector = evaluate_launch_vector(direction, wall)
	owner.velocity = jump_vector * jump_force
	time_since_jump = 0

func exit() -> void:
	pass
