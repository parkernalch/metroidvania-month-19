extends State
	
var state_machine: StateMachine
var direction: float
	
func handle_input(input: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity = Vector2(direction * 60, owner.velocity.y)
	owner.velocity += Vector2(0, 9.8)
	if Input.get_action_strength("crouch") <= 0 and owner.can_unshrink():
		state_machine.transition_to("idle")

func enter(_msg := {}) -> void:
	owner.shrink_collider()
	pass
	
func exit() -> void:
	owner.unshrink_collider()
	pass
