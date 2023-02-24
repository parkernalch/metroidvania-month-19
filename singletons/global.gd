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
