extends State
	
var state_machine: StateMachine
var direction: Vector2
var elapsed_time = 0
var stun_time = 0.125

var hit_sound = preload("res://Assets/sounds/hitHurt.wav")
onready var audio_player = owner.get_node("AudioStreamPlayer2D")

func handle_input(input: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	owner.velocity = (Vector2.UP + direction) * 250
	elapsed_time += delta
	if elapsed_time >= stun_time:
		state_machine.transition_to("idle")
	
func enter(_msg := {}) -> void:
	owner.set_animation("hurt")
	audio_player.stream = hit_sound
	audio_player.play()
	elapsed_time = 0
	direction = _msg.direction if _msg.has("direction") else Vector2.UP
	stun_time = _msg.stun_time if _msg.has("stun_time") else 0.125
	
func exit() -> void:
	pass
