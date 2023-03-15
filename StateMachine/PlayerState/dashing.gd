extends State
	
var state_machine: StateMachine
var direction: Vector2
export var dash_time = 0.25

var dash_sound = preload("res://Assets/sounds/dash.wav")
onready var audio_player = owner.get_node("AudioStreamPlayer2D")

func handle_input(input: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity =  direction * 350
	if owner.is_on_wall() and owner.can_wall_jump():
		state_machine.transition_to("sliding")
	if dash_time <= 0:
		state_machine.transition_to("falling")
	dash_time -= delta
	
func enter(_msg := {}) -> void:
	owner.set_animation("dash")
	audio_player.stream = dash_sound
	audio_player.play()
	direction = _msg.direction if _msg.has("direction") else Vector2.UP
	dash_time = 0.25
	
func exit() -> void:
	pass
