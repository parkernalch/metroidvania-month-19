extends State
	
var state_machine: StateMachine
var direction: float
	
func handle_input(input: InputEvent) -> void:
	direction = input.get_action_strength("move_right") - input.get_action_strength("move_left")
	if input.is_action_pressed("jump"):
		state_machine.transition_to("jumping", { "jumps_remaining": 0 })
	if input.is_action_released("move_right") or input.is_action_released("move_left"):
		state_machine.transition_to("idle")

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity = Vector2(1, 0) * direction
	owner.velocity += Vector2(0, 9.8)
	
func enter(_msg := {}) -> void:
	pass
	
func exit() -> void:
	pass
