extends Area2D

var cam: Camera2D
var tween_cam: Camera2D
var tween: Tween

export var transition_duration: float = 1.0

func _ready():
	assert(get_node("CollisionShape2D"))
	assert(get_node("Camera2D"))
	cam = get_node("Camera2D")
	tween_cam = Camera2D.new()
	add_child(tween_cam)
	tween = Tween.new()
	add_child(tween)
	connect("body_entered", self, "_on_player_entered")
	connect("body_exited", self, "_on_player_exited")
	
func _on_player_entered(body: Node2D):
	if body is Player:
		body.player_cam.tween_to(cam, transition_duration)
#		tween_twixt_cams(body.player_cam, cam)
#		body.player_cam.current = false
#		cam.current = true

func _on_player_exited(body: Node2D):
	if body is Player:
		body.player_cam.tween_to(null, transition_duration)
#		tween_twixt_cams(cam, body.player_cam)
#		cam.current = false
#		body.player_cam.current = true

func tween_twixt_cams(current_cam: Camera2D, target_cam: Camera2D):
	tween_cam.zoom = current_cam.zoom
	tween_cam.global_position = current_cam.global_position
	tween_cam.current = true
	var duration = 0.8
	tween.interpolate_property(
		tween_cam,
		"zoom",
		current_cam.zoom,
		target_cam.zoom,
		duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		tween_cam,
		"global_position",
		current_cam.global_position,
		target_cam.global_position,
		duration,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	tween.start()
	yield(get_tree().create_timer(duration), "timeout")
	target_cam.current = true
	tween_cam.current = false
