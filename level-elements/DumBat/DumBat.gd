extends KinematicBody

const SWING_DIST: float = 2.0

signal death

export var wandernoise: OpenSimplexNoise

var vel := Vector3()
var t = 0.0
var noise_multiplier = 1.0
var chasing = null
onready var tree = $AnimationTree

func param(p_name):
	return tree.get("parameters/conditions/" + p_name)

func set_param(p_name, val):
	return tree.set("parameters/conditions/" + p_name, val)

func _ready():
	randomize()
	# changes color of bat so to not be shared material must be unique
	$BatPivot/Bat.material_override = $BatPivot/Bat.material_override.duplicate(true)
	wandernoise.seed = randi()

func _physics_process(delta):
	t += delta
	if chasing != null and is_instance_valid(chasing):
		set_param("aggro",true)
		set_param("idle",false)
		if global_transform.origin.distance_to(chasing.global_transform.origin) < SWING_DIST:
			set_param("swing", true)
		else:
			set_param("swing", false)
	else:
		chasing = null
		set_param("aggro",false)
		set_param("idle",true)
		set_param("swing",false)
	if param("aggro") == false:
		if $GonnaCrash.is_colliding() or not $GonnaFall.is_colliding():
			rotation.y += (PI/2.0)*delta
			noise_multiplier *= -1.0
			vel = Util.vel_lerp(vel, Vector3(), delta*5.0)
		else:
			rotation.y += wandernoise.get_noise_1d(t)*delta*noise_multiplier
			vel = Util.vel_lerp(vel, -global_transform.basis.z*3.0, delta*3.0)
	else:
		var target := Basis()
		target.y = Vector3(0, 1, 0)
		target.z = -(chasing.global_transform.origin - global_transform.origin).normalized()
		target.z.y = 0.0
		target.z = target.z.normalized()
		target.x = target.y.cross(target.z)
		global_transform.basis = global_transform.basis.orthonormalized().slerp(target, delta*9.0)
		vel = Util.vel_lerp(vel, -global_transform.basis.z*Game.dumbat_chase_speed, delta*7.0)
		
	vel.y += -9.81*delta
	vel = move_and_slide(vel, Vector3(0, 1, 0))

func hit(damage: int, from_point: Vector3):
	vel = (global_transform.origin - from_point).normalized()*50.0

func swing():
	if is_instance_valid(chasing):
		chasing.hit(1, global_transform.origin)
	else:
		chasing = null

func _on_SightArea_body_entered(body):
	if not body.is_in_group("entities"):
		return
	var space_state = get_world().direct_space_state
	var result: Dictionary = space_state.intersect_ray(global_transform.origin, body.global_transform.origin, [self])
	if not result.empty():
		chasing = body
		if not chasing.is_connected("death", self, "_on_chasing_death"):
			chasing.connect("death",self,"_on_chasing_death",[chasing])

func _on_chasing_death(chasing_instance):
	if chasing_instance == chasing:
		chasing = null
