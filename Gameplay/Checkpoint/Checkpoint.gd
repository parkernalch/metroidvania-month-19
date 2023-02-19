extends Node2D

func _ready():
	self.connect("body_entered", self, "_save_game")
	
func _save_game(node):	
	SaveLoad.save_state()