extends State
	
var state_machine: StateMachine
var direction: float
var time_on_wall = 0
export var jump_control_lock_time: float = 0.25
var time_off_wall = 0
var last_wall = 0
	
func handle_input(input: InputEvent) -> void:
	if input.is_action_pressed("jump") and owner.can_wall_jump():
		state_machine.transition_to("jumping", {
			"jumps_remaining": 1,
			"control_lock_time": jump_control_lock_time,
			"direction": direction,
			"last_wall": last_wall
		})

func update(delta: float) -> void:
	direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")	
	pass
	
func physics_update(delta: float) -> void:
	time_on_wall += delta
	owner.velocity = Vector2(direction * 100, owner.velocity.y)
	owner.velocity += Vector2(0, 9.8) * min(0.3 + time_on_wall, 1.0)
	if owner.is_on_floor():
		state_machine.transition_to("idle")
	last_wall = owner.get_wall()
		
	if owner.is_on_wall():
		time_off_wall = 0
	else:
		time_off_wall += delta
	
	if time_off_wall >= 0.2:
		state_machine.transition_to("falling")
	
func enter(_msg := {}) -> void:
	owner.set_animation("slide")
	if owner.velocity.y < 0:
		owner.velocity *= Vector2(1, 0.2)
	time_on_wall = 0
	
func exit() -> void:
	pass
