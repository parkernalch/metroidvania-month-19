extends Control

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var label: Label = $Label

func _ready():
	EventBus.connect("powerup", self, "_on_got_powerup")
	
func _on_got_powerup(type: int):
	print("got " + str(type) + " powerup")
	match type:
		Global.POWERUP_TYPE.DASH:
			label.text = "DASH"
		Global.POWERUP_TYPE.DOUBLEJUMP:
			label.text = "DOUBLE JUMP"
		Global.POWERUP_TYPE.JUMP:
			label.text = "JUMP"
		Global.POWERUP_TYPE.PUNCH:
			label.text = "PUNCH"
		Global.POWERUP_TYPE.RUN:
			label.text = "RUN"
		Global.POWERUP_TYPE.SHRINK:
			label.text = "SHRINK"
		Global.POWERUP_TYPE.WALLJUMP:
			label.text = "WALL JUMP"
		_:
			label.text = ""
	animation_player.play("reveal")
	pass
