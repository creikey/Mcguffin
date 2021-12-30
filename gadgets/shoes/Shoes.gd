extends Gadget

var lifespan: float = Game.shoe_lifespan
var lifespan_bar = null

func on_activate():
	api.get_player().params.run_speed = Game.shoe_speed
	api.set_fog(true)
	
	lifespan_bar = preload("res://gadgets/Lifespanbar.tscn").instance()
	lifespan_bar.gadget = self
	lifespan_bar.max_val = Game.shoe_lifespan
	api.get_ui().add_child(lifespan_bar)

func on_deactivate():
	api.set_fog(false)
	lifespan_bar.queue_free()

func _process(delta):
	lifespan -= delta
	if lifespan <= 0.0:
		api.self_destruct(self)
