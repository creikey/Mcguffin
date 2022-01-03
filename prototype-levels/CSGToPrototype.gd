extends CSGBox

const replacement_pack = preload("res://prototype-levels/PrototypeBlock.tscn")

func _ready():
	var replacement = replacement_pack.instance()
	replacement.global_transform = global_transform
	replacement.to_shape(width, height, depth)
	get_parent().call_deferred("add_child", replacement)
	queue_free()
