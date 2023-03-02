extends EnemyState

var state_machine: StateMachine
export var delay: float = 2
var time_remaining

var attack_cooldown = false
var attack_cooldown_timer : Timer

func enter(_msg := {}) -> void:
	attack_cooldown = true
	attack_cooldown_timer = Global.add_timer(attack_cooldown_timer, attack_cooldown_time[owner.type], self, "_on_attack_cooldown_done")
	print("idle")
	time_remaining = delay	

func physics_update(delta: float) -> void:
	owner.velocity = Vector2.ZERO
	time_remaining -= delta
	if time_remaining > 0 || attack_cooldown:
		return
	if player.global_position.distance_squared_to(enemy.global_position) < Global.detection_distance:
		state_machine.transition_to("alert")
	pass

func exit():
	attack_cooldown_timer.disconnect("timeout", self, "_on_attack_cooldown_done")
	pass
	
func _on_attack_cooldown_done():
	print("cooldown_finished")
	attack_cooldown = false