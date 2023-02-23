extends KinematicBody2D

var velocity = Vector2.ZERO
var right_cast: RayCast2D
var left_cast: RayCast2D

func _ready():
	$StateMachine.connect("transitioned", self, "_stateMachine_transitioned")
	right_cast = RayCast2D.new()
	left_cast = RayCast2D.new()
	add_child(right_cast)
	add_child(left_cast)
	right_cast.cast_to = Vector2(12, 0)
	left_cast.cast_to = Vector2(-12, 0)
	right_cast.enabled = true
	left_cast.enabled = true

func _stateMachine_transitioned(new_name):
	print(new_name)
	pass

func _physics_process(delta):
	move_and_slide_with_snap(velocity.limit_length(325), Vector2.UP, Vector2.UP)

func get_wall() -> int:
	if right_cast.is_colliding():
		return 1
	if left_cast.is_colliding():
		return -1
	return 0
