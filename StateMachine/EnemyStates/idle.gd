extends EnemyState

var state_machine: StateMachine
export var delay: float = 2
var time_remaining
	
func enter(_msg := {}) -> void:
	time_remaining = delay 
	
func physics_update(delta: float) -> void:
	time_remaining -= delta
	if time_remaining > 0:
		return
	if player.global_position.distance_squared_to(enemy.global_position) < Global.detection_distance:
		state_machine.transition_to("Alert")
	pass

