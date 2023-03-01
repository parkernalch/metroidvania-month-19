extends Area2D
class_name HitBox

var damage
var enabled = false

func _ready():
	pass
	
func connect_signals():
	connect("area_entered", self, "_on_area_entered")
	pass
	
func _on_area_entered(area: Area2D):
	if area is HurtBox and area.is_enabled():
		area.take_damage(damage)
	pass
	
func enable(attack_damage: int):
	enabled = true
	damage = attack_damage
	
func disable():
	enabled = false
	damage = null

func is_enabled() -> bool:
	return enabled
