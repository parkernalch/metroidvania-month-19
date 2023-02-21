extends Area2D

onready var animation_player = $AnimationPlayer

func _ready():
	connect("body_entered", self, "_on_player_entered")
	pass
	
func _on_player_entered(body: Node2D):
	if body is Player:
		if body.has_method("evolve"):
#			body.global_position = global_position
			body.evolve()
		animation_player.play("rise")		
		yield(animation_player, "animation_finished")
		queue_free()
	pass
