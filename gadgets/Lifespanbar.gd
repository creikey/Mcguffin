extends Control

var gadget = null
var max_val: float = 5.0

func _process(delta):
	$ProgressBar.value = gadget.lifespan/max_val
