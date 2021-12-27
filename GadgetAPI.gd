extends Node

# node all gadgets have reference to in order to enact their gadgetry

class_name GadgetAPI

# gadgets do things to the player and optionally add a ui node to the ui canvaslayer
export (NodePath) var _player_path
export (NodePath) var _ui_path

onready var _player = get_node(_player_path)
onready var _ui = get_node(_ui_path)

func get_player() -> Node:
	return _player

func get_ui() -> Node:
	return _ui

func self_destruct(gadget_ref):
	_player.on_gadget_request_destroy(gadget_ref)
