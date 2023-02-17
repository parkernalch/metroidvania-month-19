extends TileMap


func _ready():
	yield(get_tree(), "idle_frame")
#	SaveLoad.load_state()
