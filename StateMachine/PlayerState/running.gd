extends State
	
var state_machine: StateMachine
var direction: float
	
func handle_input(input: InputEvent) -> void:
	if input.is_action_pressed("jump") and owner.can_jump():
		state_machine.transition_to("jumping", { "jumps_remaining": 1 })
	if input.is_action_pressed("dash") and owner.can_dash():
		state_machine.transition_to("dashing", {
			"jumps_remaining": 0,
			"direction": Vector2(direction, 0)
		})

func update(delta: float) -> void:
	direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")	
	if direction == 0:
		state_machine.transition_to("idle")
	if Input.get_action_strength("crouch") > 0 and owner.can_shrink():
		state_machine.transition_to("shrinking")
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity = Vector2(120, 0) * direction
	owner.velocity += Vector2(0, 9.8)
	if not owner.is_on_floor():
		state_machine.transition_to("falling")
	
func enter(_msg := {}) -> void:
	pass
	
func exit() -> void:
	pass
