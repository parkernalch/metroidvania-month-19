extends EnemyState

var state_machine: StateMachine

func enter(_msg := {}) -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	state_machine.transition_to("Idle")
