extends State
	
var state_machine: StateMachine
export var falling_gravity_modifier: float = 2
var jumps_remaining = 0
var direction = 0

func handle_input(input: InputEvent) -> void:
	if input.is_action_pressed("jump") and jumps_remaining > 0 and owner.can_double_jump():
		state_machine.transition_to("jumping", { "jumps_remaining": jumps_remaining - 1})
	if input.is_action_pressed("dash") and jumps_remaining > 0 and owner.can_dash():
		state_machine.transition_to("dashing", {
			"jumps_remaining": jumps_remaining - 1,
			"direction": Vector2(direction, 0)
		})

func update(delta: float) -> void:
	direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
func physics_update(delta: float) -> void:
	if owner.is_on_floor():
		state_machine.transition_to("idle")
	elif owner.is_on_wall() and owner.can_wall_jump():
		state_machine.transition_to("sliding")
	owner.velocity = Vector2(direction * owner.horizontal_speed, owner.velocity.y)
	owner.velocity += Vector2.DOWN * 9.8 * falling_gravity_modifier
	pass
	
func enter(_msg := {}) -> void:
	owner.velocity *= 0.4
	jumps_remaining = _msg.jumps_remaining if _msg.has("jumps_remaining") else 0
	
func exit() -> void:
	pass
