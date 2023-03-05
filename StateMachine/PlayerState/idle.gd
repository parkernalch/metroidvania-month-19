extends State
	
var state_machine: StateMachine
	
func handle_input(input: InputEvent) -> void:
	if input.is_action_pressed("jump") and owner.can_jump():
		state_machine.transition_to("jumping", { "jumps_remaining" : 1})
	pass

func update(delta: float) -> void:
	if Input.get_action_strength("move_right") - Input.get_action_strength("move_left"):
		state_machine.transition_to("running" if owner.can_run() else "walking")
	if Input.get_action_strength("crouch") > 0 and owner.can_shrink():
		state_machine.transition_to("shrinking")
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity += Vector2(0, 9.8)
	owner.velocity *= Vector2(0.3, 1)
	if not owner.is_on_floor() and not owner.is_on_wall():
		state_machine.transition_to("falling")
	pass
	
func enter(_msg := {}) -> void:
	owner.set_animation("idle")
	pass
	
func exit() -> void:
	pass
