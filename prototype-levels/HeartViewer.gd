extends HBoxContainer

export var heart_pack: PackedScene

var health: int = Game.max_health

var t: float = 0.0
var hearts: Array = []

func _ready():
	for i in range(Game.max_health):
		var new_heart = heart_pack.instance()
		hearts.append(new_heart)
		add_child(new_heart)

func _process(delta):
	t += delta
	for i in range(4):
		var target: float = 1.0
		if health < i + 1:
			target = 0.0
		var n: Control = hearts[i]
		n.modulate.a = lerp(n.modulate.a, target, delta*14.0)
	
	var last_heart_scaling: float = 1.0
	if health == 1:
		last_heart_scaling = 1.0 + sin(t*3.0)*0.2
	hearts[0].rect_scale.x = lerp(hearts[0].rect_scale.x, last_heart_scaling, delta*9.0)
	hearts[0].rect_scale.y = hearts[0].rect_scale.x
