extends Gadget

export var pearl_orb: PackedScene

var lifespan: float = Game.pearl_teleport_time
var lifespan_bar = null
var pearl_gfx: Spatial = null

func on_activate():
	pearl_gfx = pearl_orb.instance()
	api.spawn_in(pearl_gfx)
	pearl_gfx.global_transform.origin = api.get_player_camera().global_transform.origin + api.get_player_camera().global_transform.basis.z*-2.0
	pearl_gfx.vel = api.get_player_camera().global_transform.basis.z*-Util.calc_vel(Game.pearl_max_height, Game.pearl_airtime)
	pearl_gfx.connect("death", self, "on_pearl_death")
	
	lifespan_bar = preload("res://gadgets/Lifespanbar.tscn").instance()
	lifespan_bar.gadget = self
	lifespan_bar.max_val = Game.pearl_teleport_time
	api.add_ui_node(lifespan_bar)

func on_deactivate():
	lifespan_bar.queue_free()
	pearl_gfx.queue_free()
	lifespan = Game.pearl_teleport_time

func _process(delta):
	lifespan -= delta
	if lifespan <= 0.0:
		api.get_player().global_transform.origin = pearl_gfx.global_transform.origin + Vector3(0, 1, 0)
		api.self_destruct(self)
		
func on_pearl_death():
	api.get_player().kill()
