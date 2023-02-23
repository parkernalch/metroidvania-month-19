extends State
	
var state_machine: StateMachine
	
func handle_input(input: InputEvent) -> void:
	if input.is_action_pressed("jump"):
		state_machine.transition_to("jumping", { "jumps_remaining" : 1})
	pass

func update(delta: float) -> void:
	if Input.get_action_strength("move_right") - Input.get_action_strength("move_left"):
		state_machine.transition_to("running")
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity += Vector2(0, 9.8)
	owner.velocity *= Vector2(0.3, 1)
	if not owner.is_on_floor() and not owner.is_on_wall():
		state_machine.transition_to("falling")
	pass
	
func enter(_msg := {}) -> void:
	pass
	
func exit() -> void:
	pass
