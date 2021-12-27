extends KinematicBody

class_name Player

signal death
signal toolbelt_changed # so ui can react to it 

# reset on death, and gadgets can modify them. always reset to defaults when
# gadget is unequipped
var default_params = {
	mouse_sense = 0.01,
	run_speed = 10.0,
	feet_accel_factor = 9.0,
	air_accel_factor = 2.0,
	gravity = 15.0,
	jump_vel = 8.0,
	can_jump_func = funcref(self, "can_jump"),
}

onready var params = default_params.duplicate(true)
onready var torso = $Torso
onready var cam = $Torso/Camera
onready var interact_cast: RayCast = $Torso/Camera/InteractCast
onready var toolbelt: Node = $Toolbelt # children must be Gadgets
onready var gadget_api: GadgetAPI = $"../GadgetAPI" # gadgets need to see and feel too
var money: int = 500
var activated_gadget: Gadget = null setget set_activated_gadget

var vel := Vector3()

func set_activated_gadget(new_activated_gadget):
	if activated_gadget != null:
		activated_gadget.deactivate()
	params = default_params.duplicate(true)
	activated_gadget = new_activated_gadget
	if activated_gadget != null:
		activated_gadget.api = gadget_api
		activated_gadget.activate()

func _ready():
	interact_cast.add_exception(self)

func spawn(spawnpoint: Transform):
	vel = Vector3()
	global_transform = spawnpoint
	_clear_toolbelt()
	params = default_params.duplicate(true)
	money = 500

func try_purchase(gadget: GadgetPurchase):
	if money < gadget.price:
		return
	if toolbelt.get_children().size() < 5:
		money -= gadget.price
		toolbelt.add_child(gadget.scene.instance())
		emit_signal("toolbelt_changed")

func on_gadget_request_destroy(gadget_ref):
	if gadget_ref == activated_gadget:
		self.activated_gadget = null
	gadget_ref.queue_free()
	emit_signal("toolbelt_changed")

func _clear_toolbelt():
	self.activated_gadget = null
	for c in toolbelt.get_children():
		c.queue_free()
	emit_signal("toolbelt_changed")

func can_jump() -> bool:
	return is_on_floor()

func hit(damage: int, from_point: Vector3):
	vel = (global_transform.origin - from_point).normalized()*50.0

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
	elif event.is_action_pressed("interact"):
		if interact_cast.is_colliding() and interact_cast.get_collider().is_in_group("interactible"):
			interact_cast.get_collider().interact(self, interact_cast.get_collision_point())
	elif event.is_pressed() and event is InputEventKey and (event.scancode >= KEY_1 and event.scancode <= KEY_5):
		var selected_gadget_index: int = event.scancode - KEY_1
		
		if selected_gadget_index < toolbelt.get_children().size():
			var selected_gadget = toolbelt.get_child(selected_gadget_index)
			if selected_gadget == self.activated_gadget:
				self.activated_gadget = null # toggle when you equip gadget again
			else:
				self.activated_gadget = selected_gadget
		emit_signal("toolbelt_changed")

func _physics_process(delta):
	if global_transform.origin.y <= -5.0:
		emit_signal("death")
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
	
	if params.can_jump_func.call_func() and Input.is_action_just_pressed("jump"):
		vel.y = params.jump_vel
	
	vel.y -= params.gravity*delta
	
	vel = move_and_slide(vel, Vector3(0, 1, 0))
