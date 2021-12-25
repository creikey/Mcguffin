extends KinematicBody

const default_params = {
	mouse_sense = 0.01,
	run_speed = 10.0,
	feet_accel_factor = 9.0,
	air_accel_factor = 2.0,
	gravity = 15.0,
	jump_vel = 8.0,
}

onready var params = default_params.duplicate(true)
onready var torso = $Torso
onready var cam = $Torso/Camera

var vel := Vector3()

func spawn(spawnpoint: Vector3):
	vel = Vector3()
	global_transform.origin = spawnpoint
	params = default_params.duplicate(true)

func _input(event):
	if event.is_action_pressed("capture_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("uncapture_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		torso.rotation.y -= event.relative.x*params.mouse_sense
		cam.rotation.x -= event.relative.y*params.mouse_sense
		cam.rotation.x = clamp(cam.rotation.x, -PI/1.9, PI/1.9)

func _physics_process(delta):
	var forward_backward: float = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	var left_right: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var movement: Vector3 = -cam.global_transform.basis.z*forward_backward + cam.global_transform.basis.x*left_right
	movement.y = 0.0
	movement = movement.normalized()*params.run_speed
	
	var accel_factor: float = params.air_accel_factor
	if is_on_floor():
		accel_factor = params.feet_accel_factor
	vel.x = lerp(vel.x, movement.x, delta*accel_factor)
	vel.z = lerp(vel.z, movement.z, delta*accel_factor)
	
	if (is_on_floor() or is_on_wall()) and Input.is_action_just_pressed("jump"):
		vel.y = params.jump_vel
	
	vel.y -= params.gravity*delta
	
	vel = move_and_slide(vel, Vector3(0, 1, 0))
