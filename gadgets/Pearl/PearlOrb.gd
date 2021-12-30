extends KinematicBody

var vel = Vector3()
signal death

func hit(_damage: int, from_point: Vector3):
	queue_free()
	emit_signal("death")

func _physics_process(delta):
	vel.y += Util.calc_gravity(Game.pearl_max_height, Game.pearl_airtime) * delta
	vel = move_and_slide(vel, Vector3(0, 1, 0))
	
	if is_on_floor():
		vel = Vector3()
