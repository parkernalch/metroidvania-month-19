extends State
class_name EnemyState

var enemy: BaseEnemy
var player: Player

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
