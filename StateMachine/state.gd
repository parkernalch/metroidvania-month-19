extends Node
class_name State

func _ready():
	yield(owner, "ready")
	pass
	
func handle_input(input: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
	
func enter(_msg := {}) -> void:
	pass
	
func exit() -> void:
	pass
