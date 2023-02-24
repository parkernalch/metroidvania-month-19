extends Area2D
class_name Pickup

onready var animation_player = $AnimationPlayer
export(Global.POWERUP_TYPE) var type = Global.POWERUP_TYPE.WALLJUMP

func _ready():
	connect("body_entered", self, "_on_player_entered")
	pass
	
func _on_player_entered(body: Node2D):
	if body.has_method("evolve"):
		body.evolve(type)
		animation_player.play("rise")		
		yield(animation_player, "animation_finished")
		queue_free()
	pass
