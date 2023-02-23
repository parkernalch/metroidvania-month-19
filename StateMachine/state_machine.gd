extends Node
class_name StateMachine

signal transitioned(new_state_name)

export var initial_state := NodePath()

onready var state: State = get_node(initial_state)

func _ready() -> void:
	yield(owner, "ready")
	for child in get_children():
		if not child is State:
			break
		child.state_machine = self
		child.owner = owner
	state.enter()
	
func _unhandled_input(input: InputEvent) -> void:
	state.handle_input(input)
	
func _process(delta: float) -> void:
	state.update(delta)
	
func _physics_process(delta: float) -> void:
	state.physics_update(delta)
	
func transition_to(new_state: String, msg: Dictionary = {}) -> void:
	if not has_node(new_state):
		return
	state.exit()
	state = get_node(new_state)
	state.enter(msg)
	emit_signal("transitioned", new_state)
	
