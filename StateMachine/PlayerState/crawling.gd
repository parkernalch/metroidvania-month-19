extends State
	
var state_machine: StateMachine
var direction: float
	
func handle_input(input: InputEvent) -> void:
	direction = input.get_action_strength("move_right") - input.get_action_strength("move_left")
	if input.is_action_pressed("jump") and owner.can_jump():
		state_machine.transition_to("jumping", { "jumps_remaining": 0 })

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity = Vector2(1, 0) * direction
	owner.velocity += Vector2(0, 9.8)
	if direction == 0:
		state_machine.transition_to("idle")
	
func enter(_msg := {}) -> void:
	owner.set_animation("idle")
	pass
	
func exit() -> void:
	pass
