extends State
	
var state_machine: StateMachine
var direction: Vector2
export var dash_time = 0.25
	
func handle_input(input: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity =  direction * 350
	if owner.is_on_wall() :
		state_machine.transition_to("sliding")
	if dash_time <= 0:
		state_machine.transition_to("falling")
	dash_time -= delta
	
func enter(_msg := {}) -> void:
	direction = _msg.direction if _msg.has("direction") else Vector2.UP
	dash_time = 0.25
	
func exit() -> void:
	pass
