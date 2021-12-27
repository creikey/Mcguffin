extends Node

class_name Gadget

var api: GadgetAPI = null # must be set before activate, interface to the outside!
export var inventory_icon: Texture
var activated: bool = false

func _ready():
	set_process(false)
	set_physics_process(false)

func activate():
	activated = true
	set_process(true)
	set_physics_process(true)
	on_activate()
	
func deactivate():
	activated = false
	set_process(false)
	set_physics_process(false)
	on_deactivate()

func on_activate():
	# override this method
	pass

func on_deactivate():
	# override this method
	pass
