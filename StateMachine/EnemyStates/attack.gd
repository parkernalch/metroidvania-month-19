extends EnemyState

var state_machine: StateMachine

var windup_timer : Timer
var attack_timer : Timer

var charge_direction : Vector2

var hit_area : Area2D

var attacking = false

func enter(_msg := {}) -> void:
	charge_direction = enemy.global_position.direction_to(player.global_position)
	hit_area = owner.get_node("hitArea")
	hit_area.connect("body_entered", self, "_player_hit")
	print("attack")
	attacking = false
	owner.velocity = Vector2.ZERO
	windup_timer = Global.add_timer(windup_timer, windup_time[owner.type], self, "_on_windup_timeout")	
	if owner.type == 0:
		attack_timer = Global.add_timer(attack_timer, 2, self, "_attack_done")

func _physics_process(delta):
	if attacking:
		match owner.type:
			0: handle_charger_attack()
			1: handle_jumper_attack()
			2: handle_shooter_attack()

func _player_hit(player):
	if player.name == "StatefulPlayer":
		if player.has_method("take_damage") && owner.type == 0:
			player.take_damage(20, owner.global_position, 2)
		owner.velocity = Vector2.ZERO
		attacking = false
		state_machine.transition_to("idle")

func handle_charger_attack():
	if owner.floor_side() == 0 or owner.floor_side() == -1 and charge_direction.x < 0 or owner.floor_side() == 1 and charge_direction.x > 0:
		owner.velocity.x = (charge_direction * enemy_speed[owner.type]).x * 2
	else:
		owner.velocity = Vector2.ZERO
		
func handle_jumper_attack():
	owner.velocity = (Vector2.UP * 2 + Vector2.RIGHT) * 250;
	pass

func handle_shooter_attack():
	pass

func _on_windup_timeout():
	attacking = true

func _attack_done():
	attacking = false
	state_machine.transition_to("idle")

func exit():
	windup_timer.disconnect("timeout", self, "_on_windup_timeout")
	if attack_timer:
		attack_timer.disconnect("timeout", self, "_attack_done")
	pass
