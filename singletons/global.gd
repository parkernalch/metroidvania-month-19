extends Node

var detection_distance = 10000

enum POWERUP_TYPE {
	RUN = 1 << 0,
	JUMP = 1 << 1,
	DOUBLEJUMP = 1 << 2,
	DASH = 1 << 3,
	PUNCH = 1 << 4,
	SHRINK = 1 << 5,
	WALLJUMP = 1 << 6
}

func add_timer(timer, wait_time, parent, connected_func, start=true, one_shot=true):
	timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = one_shot
	parent.add_child(timer)
	timer.connect("timeout", parent, connected_func)
	if start:
		timer.start()
	return timer
