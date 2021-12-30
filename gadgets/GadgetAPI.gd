extends Node

# node all gadgets have reference to in order to enact their gadgetry

class_name GadgetAPI

const _fog_environment: Environment = preload("res://fog_environment.tres")

# gadgets do things to the player and optionally add a ui node to the ui canvaslayer
export (NodePath) var _player_path
export (NodePath) var _ui_path
export (NodePath) var _env_node_path # used for fog!

onready var _player = get_node(_player_path)
onready var _ui = get_node(_ui_path)
onready var _env_node: WorldEnvironment = get_node(_env_node_path)
onready var _old_environment: Environment = _env_node.environment.duplicate(false)
var _fog_enabled: bool = false

func get_player() -> Node:
	return _player

func get_player_camera() -> Camera:
	return _player.get_node("Torso/Camera")

func get_ui() -> Node:
	return _ui

func add_ui_node(node: Control):
	_ui.add_child(node)
	_ui.move_child(node, 0)

func self_destruct(gadget_ref):
	_player.on_gadget_request_destroy(gadget_ref)

func spawn_in(node: Node):
	get_parent().add_child(node)

func _process(delta):
	var env: Environment = _env_node.environment
	var target_env: Environment = _old_environment
	var target_fog_bubble_alpha: float = 0.0
	var fog_bubble_mat: SpatialMaterial = _player.get_node("FogBubble").material_override
	if _fog_enabled:
		target_env = _fog_environment
		target_fog_bubble_alpha = 1.0
	var delta_factor: float = delta
	if _fog_enabled:
		delta_factor *= 9.0
	
	env.fog_depth_begin = lerp(env.fog_depth_begin, target_env.fog_depth_begin, delta_factor)
	env.fog_depth_end = lerp(env.fog_depth_end, target_env.fog_depth_end, delta_factor)
	fog_bubble_mat.albedo_color.a = lerp(fog_bubble_mat.albedo_color.a, target_fog_bubble_alpha, delta_factor*3.0)

func set_fog(enabled: bool):
	_fog_enabled = enabled
