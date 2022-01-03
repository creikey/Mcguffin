extends Control

var gadget = null
var max_val: float = 5.0

func _process(delta):
	if not is_queued_for_deletion() and is_instance_valid(gadget):
		$ProgressBar.value = gadget.lifespan/max_val
