extends Node

class_name Gadget

var api: GadgetAPI = null # must be set before activate, interface to the outside!
export var inventory_icon: Texture
var activated: bool = false setget set_activated

func set_activated(new_activated):
	activated = new_activated
	set_process(activated)
	set_physics_process(activated)
	set_process_input(activated)

func _ready():
	self.activated = false

func activate():
	if not activated:
		self.activated = true
		on_activate()
	
func deactivate():
	if activated:
		self.activated = false
		on_deactivate()

func on_activate():
	# override this method
	pass

func on_deactivate():
	# override this method
	pass
