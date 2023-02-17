extends EnemyState

var state_machine: StateMachine
var disinterest_timer: Timer
var interest_timer: Timer

func enter(_msg := {}) -> void:
	disinterest_timer = Timer.new()
	disinterest_timer.wait_time = 3
	disinterest_timer.one_shot = true
	add_child(disinterest_timer)
	disinterest_timer.connect("timeout", self, "_on_disinterestTimer_timeout")
	
	interest_timer = Timer.new()
	interest_timer.wait_time = 1
	disinterest_timer.one_shot = true
	add_child(interest_timer)
	interest_timer.connect("timeout", self, "_on_interestTimer_timeout")
	interest_timer.start()
	
func physics_update(delta: float) -> void:
	var sq_distance_to_player = player.global_position.distance_squared_to(enemy.global_position)
	
	if interest_timer.is_stopped() and sq_distance_to_player < Global.detection_distance:
		interest_timer.start()
		disinterest_timer.stop()
	elif disinterest_timer.is_stopped() and sq_distance_to_player > Global.detection_distance * 1.2:
		interest_timer.stop()
		disinterest_timer.start()
	else:
		pass

func _on_disinterestTimer_timeout():
	state_machine.transition_to("Idle")

func _on_interestTimer_timeout():
	state_machine.transition_to("Attack")
	
func exit():
	interest_timer.disconnect("timeout", self, "_on_interestTimer_timeout")
	disinterest_timer.disconnect("timeout", self, "_on_disinterestTimer_timeout")
	pass
