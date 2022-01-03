extends Gadget

class_name Shoes

var lifespan: float = Game.shoe_lifespan
var lifespan_bar = null
var running: bool = false setget set_running

func set_running(new_running: bool):
	api.set_fog(new_running)
	if not running and new_running:
		api.set_player_param("run_speed", Game.shoe_speed)
	if running and not new_running:
		api.reset_player_params()
	running = new_running

func on_activate():
	lifespan_bar = preload("res://gadgets/Lifespanbar.tscn").instance()
	lifespan_bar.gadget = self
	lifespan_bar.max_val = Game.shoe_lifespan
	api.add_ui_node(lifespan_bar)

func on_deactivate():
	self.running = false
	lifespan_bar.queue_free()

func _input(event):
	if event.is_action("primary_activate"):
		self.running = event.is_pressed()

func _process(delta):
	if running:
		lifespan -= delta
		if lifespan <= 0.0:
			api.self_destruct(self)
