extends EnemyState

var state_machine: StateMachine

var windup_timer : Timer
var attack_timer : Timer

var attacking = false

func enter(_msg := {}) -> void:
	print("attack")
	attacking = false
	owner.velocity = Vector2.ZERO
	windup_timer = Global.add_timer(windup_timer, windup_time[owner.type], self, "_on_windup_timeout")	
	if owner.type == 0:
		attack_timer = Global.add_timer(attack_timer, 3, self, "_attack_done")

func _physics_process(delta):
	if attacking:
		match owner.type:
			0: handle_charger_attack()
			1: handle_jumper_attack()
			2: handle_shooter_attack()
		
func handle_charger_attack():
	if owner.on_floor():
		owner.velocity.x = (enemy.global_position.direction_to(player.global_position) * enemy_speed[owner.type]).x * 2
	else:
		owner.velocity = Vector2.ZERO
		
func handle_jumper_attack():
	pass

func handle_shooter_attack():
	pass

func _on_windup_timeout():
	attacking = true

func _attack_done():
	attacking = false
	state_machine.transition_to("Idle")

func exit():
	windup_timer.disconnect("timeout", self, "_on_windup_timeout")
	if attack_timer:
		attack_timer.disconnect("timeout", self, "_attack_done")
	pass