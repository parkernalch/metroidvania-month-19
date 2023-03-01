extends Area2D
class_name HurtBox

var enabled = false

signal got_damage(value)

func _ready():
	assert(has_node("CollisionShape2D"))

func enable():
	enabled = true
	
func disable():
	enabled = false

func take_damage(damage: int) -> void:
	emit_signal("got_damage", damage)

func is_enabled() -> bool:
	return enabled
