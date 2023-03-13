extends Camera2D

var tween: Tween
export var duration: float = 0.8
var lock_position: bool = false
var locked_gpos: Vector2

func _ready():
	process_mode = Camera2D.CAMERA2D_PROCESS_PHYSICS
	tween = Tween.new()
	add_child(tween)
	
func tween_to(new_camera, transition_duration=duration):
	var target_zoom = new_camera.zoom if new_camera != null else Vector2(0.35, 0.35)
	var target_pos = to_local(new_camera.global_position) if new_camera != null else Vector2.ZERO
	locked_gpos = new_camera.global_position if new_camera != null else Vector2.ZERO
	lock_position = new_camera != null
	print("tweening to new camera " + str(lock_position))
	set_physics_process(false)
	
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		target_zoom,
		transition_duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	if lock_position:
		tween.interpolate_property(
			self,
			"global_position",
			global_position,
			locked_gpos,
			transition_duration,
			Tween.TRANS_EXPO,
			Tween.EASE_OUT
		)
	else:
		tween.interpolate_property(
			self,
			"position",
			position,
			target_pos,
			transition_duration,
			Tween.TRANS_EXPO,
			Tween.EASE_OUT
		)
	tween.start()
	yield(get_tree().create_timer(transition_duration), "timeout")
	set_physics_process(true)

func _physics_process(_delta):
	if lock_position:
#		print("locking position")
		global_position = locked_gpos
