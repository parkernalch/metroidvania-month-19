extends Node

var save_filename := "user://game_data.save"

func save_state():
	var save_file = File.new()
	save_file.open(save_filename, File.WRITE)
	var saved_nodes = get_tree().get_nodes_in_group("Persist")
	
	for node in saved_nodes:
		print(node.filename)
		if node.filename.empty():
			break
		
		var node_data = node.get_save_data()
		save_file.store_line(to_json(node_data))
	
	save_file.close()
	
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_state()
	
func load_state():
	var save_file = File.new()
	if not save_file.file_exists(save_filename):
		return
	
	save_file.open(save_filename, File.READ)
	
	for node in get_tree().get_nodes_in_group("Persist"):
		node.queue_free()
		
	while save_file.get_position() < save_file.get_len():
		var parsed_node_data = parse_json(save_file.get_line())
		var loaded_node = load(parsed_node_data.filename).instance()
		get_node(parsed_node_data.parent).call_deferred("add_child", loaded_node)
		loaded_node.load_save_data(parsed_node_data)
		loaded_node.add_to_group("Persist")
		
	save_file.close()
	
