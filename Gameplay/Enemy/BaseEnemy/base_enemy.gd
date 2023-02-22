extends Node2D
class_name BaseEnemy

var max_health: int
var current_health: int

var animation_player: AnimationPlayer

var current_state
var states

var state_map = {}

func _ready():
	add_to_group("Enemy")
	state_map = get_states()
	animation_player = get_node("AnimationPlayer")
	
func get_states() -> Dictionary:
	var state_map = {}
	var states_list = get_node("States")
	if states_list:
		for state in states_list.get_children():
			state_map[state.name] = state
			print(state)
	return {}
	
func _process(delta):
	pass
	
func _physics_process(delta):
	pass
	
func attack() -> void:
	pass

func get_save_data():
	return {
		"position": {
			"x": global_position.x,
			"y": global_position.y
		},
		"health": current_health,
		"filename": get_filename(),
		"parent": get_parent().get_path()
	}


func load_save_data(data):
	global_position = Vector2(data.position.x, data.position.y)
	current_health = data.health

func take_damage(amount) -> int:
	current_health -= amount
	animation_player.play("take_damage")
	if current_health < 0:
		die()
	return int(max(0, current_health))
	
func die():
	yield(animation_player.play("die"), "finished")
	queue_free()
	pass
