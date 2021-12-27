extends Gadget

var lifespan: float = 5.0
var lifespan_bar = null

func on_activate():
	api.get_player().params.run_speed = 30.0
	lifespan_bar = preload("res://gadgets/Lifespanbar.tscn").instance()
	lifespan_bar.gadget = self
	lifespan_bar.max_val = 5.0
	api.get_ui().add_child(lifespan_bar)

func on_deactivate():
	lifespan_bar.queue_free()

func _process(delta):
	lifespan -= delta
	if lifespan <= 0.0:
		api.self_destruct(self)
