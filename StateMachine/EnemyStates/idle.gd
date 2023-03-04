extends EnemyState

var state_machine: StateMachine
export var delay: float = 2
var time_remaining

var attack_cooldown = false
var attack_cooldown_timer : Timer

var wander_timer : Timer
var wander_direction : Vector2
var wander = false
var wander_stop_timer : Timer

func enter(_msg := {}) -> void:
	attack_cooldown = true
	attack_cooldown_timer = Global.add_timer(attack_cooldown_timer, attack_cooldown_time[owner.type], self, "_on_attack_cooldown_done")

	var wander_time = get_random_number(2.0, 10.0)
	wander_timer = Global.add_timer(wander_timer, wander_time, self, "_wander_timer_done")
	print("idle")
	time_remaining = delay	

func physics_update(delta: float) -> void:
	time_remaining -= delta
	if wander:
		if wander_direction == Vector2.LEFT && owner.floor_side() == 1 or wander_direction == Vector2.RIGHT && owner.floor_side() == -1:
			stop_wander()
		else:
			owner.velocity = wander_direction * 40;
	else:
		owner.velocity = Vector2.ZERO
	if time_remaining > 0 || attack_cooldown:
		return
	if player.global_position.distance_squared_to(enemy.global_position) < Global.detection_distance:
		state_machine.transition_to("alert")
	pass
		
func stop_wander():
	var wander_time = get_random_number(2.0, 10.0)
	wander_timer.wait_time = wander_time
	wander_timer.start()
	wander = false
		
func get_random_number(start, end):
	var rng = RandomNumberGenerator.new()
	randomize()
	return rng.randf_range(start, end)

func _wander_stop():
	stop_wander()

func _wander_timer_done():
	var wander_stop_time = get_random_number(1.0, 4.0)
	wander_stop_timer = Global.add_timer(wander_stop_timer, wander_stop_time, self, "_wander_stop")
	match owner.floor_side():
		-1: 
			wander_direction = Vector2.LEFT
		1:
			wander_direction = Vector2.RIGHT
		0:
			var wander_dir_rng = get_random_number(0.0, 1.0)
			wander_direction = Vector2.LEFT if wander_dir_rng == 0.0 else Vector2.RIGHT
	wander = true

func exit():
	attack_cooldown_timer.disconnect("timeout", self, "_on_attack_cooldown_done")
	pass
	
func _on_attack_cooldown_done():
	attack_cooldown = false
