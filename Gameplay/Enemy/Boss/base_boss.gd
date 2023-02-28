extends Node2D
class_name BaseBoss

var player: Node2D
onready var boss: Node2D = $"%Boss"
var boss_velocity = Vector2.ZERO

onready var path: Path2D = $Path2D
onready var follow: PathFollow2D = $Path2D/PathFollow2D

var g1 = 9.8
var g2 = 9.8

var state: int
enum BOSS_STATE {
	IDLE,
	ATTACK,
	DEFEND,
}

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	state = BOSS_STATE.IDLE
	follow.rotate = false
	follow.cubic_interp = true
	pass

func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_SPACE:
			attack()

func attack():
	if state == BOSS_STATE.ATTACK:
		return
	jump_attack()
	pass

func get_jump_trajectory() -> Vector2:
	if not player:
		return Vector2.ZERO
	var distance_to_jump = (player.global_position - boss.global_position).length()

# 	Maybe works a bit better? Can't tell
	var t = 0.5
	var h = 2
	g1 = 2 * h / (t * t)
	g2 = 6 * g1
	var f = sqrt(h / g1)
	var v_x = distance_to_jump / t * 0.75
	var numerator = 1/2 * g1 * pow(t, 2) - g1 * t * f - 0.5 * h
	var denominator = f - t
	var v_y = numerator / denominator * 18
	
	return Vector2(sign((player.global_position - boss.global_position).x) * v_x, -v_y)

func jump_attack():
	state = BOSS_STATE.ATTACK
	var launch_vector = get_jump_trajectory()
	print(launch_vector)
	boss_velocity = launch_vector
	
func take_damage():
	pass
	
func die():
	pass
	
func _physics_process(delta):
#	boss_velocity += Vector2(0, 9.8)
	if boss_velocity.y > 0:
		boss_velocity += Vector2(0, g2)
	else:
		boss_velocity += Vector2(0, g1)
	boss_velocity = boss.move_and_slide(boss_velocity, Vector2.UP)
	if state == BOSS_STATE.ATTACK and boss.is_on_floor():
		state = BOSS_STATE.IDLE
		boss_velocity *= Vector2(0, 1)
	pass
#	if boss.is_on_floor() and state == BOSS_STATE.ATTACK:
#		state == BOSS_STATE.IDLE
