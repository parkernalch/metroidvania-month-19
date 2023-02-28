extends EnemyState

var state_machine: StateMachine
var disinterest_timer: Timer
var interest_timer: Timer

func enter(_msg := {}) -> void:
	print("alert")
	disinterest_timer = Global.add_timer(disinterest_timer, 3, self, "_on_disinterestTimer_timeout", false)
	interest_timer = Global.add_timer(interest_timer, 1, self, "_on_interestTimer_timeout")

func physics_update(delta: float) -> void:
	var sq_distance_to_player = player.global_position.distance_squared_to(enemy.global_position)

	if sq_distance_to_player < Global.detection_distance:
		owner.velocity.x = (enemy.global_position.direction_to(player.global_position) * enemy_speed[owner.type]).x / 2

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
