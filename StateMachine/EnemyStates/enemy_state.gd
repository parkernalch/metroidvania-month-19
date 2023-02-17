extends State
class_name EnemyState

var enemy: BaseEnemy
var player: Player

func _ready() -> void:
	yield(owner, "ready")
	enemy = owner as BaseEnemy
	assert(enemy != null)
	player = get_tree().get_nodes_in_group("Player")[0]
	assert(player != null)
