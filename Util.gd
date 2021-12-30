extends Node

class_name Util

static func vel_lerp(from: Vector3, to: Vector3, t: float) -> Vector3:
	var to_return: Vector3 = lerp(from, to, t)
	to_return.y = from.y
	return to_return

# CALCULUS
static func calc_vel(height: float, time: float) -> float:
	time /= 2.0
	return (2.0 * height) / time

static func calc_gravity(height: float, time: float) -> float:
	time /= 2.0
	return (-2.0 * height) / (time * time)

func _ready():
	var test_vel = calc_vel(1.0, 1.0)
	var test_grav = calc_gravity(1.0, 1.0)
	
	var pos = 0.0
	var vel = test_vel
	# one second of simulation
	for i in 60:
		vel += test_grav*(1.0 / 60.0)
		pos += vel*(1.0 / 60)
	assert(abs(pos - 0.0) <= (1.0 / 60.0)*4.0)
