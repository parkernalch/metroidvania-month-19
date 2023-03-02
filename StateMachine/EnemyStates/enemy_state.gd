extends State
class_name EnemyState

var enemy: BaseEnemy
var player: Node2D

# attack range / speed for enemies (0: charger) (1: jumper) (2: shooter) 
var attack_range = [200, 250, 400]
var enemy_speed = [100, 60, 30]
var windup_time = [1, 2, 3]
var attack_cooldown_time = [1.5, 1, 1]

func _ready() -> void:
	yield(owner, "ready")
	set_enemy()
	assert(enemy != null)
	set_player()
	assert(player != null)


func _process(delta):
	if !is_instance_valid(player):
		set_player()
	if !is_instance_valid(enemy):
		set_enemy()

func set_player():
	player = get_tree().get_nodes_in_group("Player")[0]

func set_enemy():
	enemy = owner as BaseEnemy
