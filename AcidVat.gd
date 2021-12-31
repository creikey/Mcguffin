extends Area

var t: float = 0.0
var acid_concentration: float = 0.0

func _process(delta):
	t += delta
	var mat: SpatialMaterial = $MeshInstance.material_override
	mat.uv1_offset.x += delta
	mat.uv1_offset.y += delta*2.0*sin(t + cos(t*0.7))

	if get_entities().size() > 0:
		acid_concentration += delta
		if acid_concentration > 0.5:
			for e in get_entities():
				e.hit(1, global_transform.origin)
			acid_concentration = 0.0
	else:
		acid_concentration = 0.0

func get_entities() -> Array:
	var to_return: Array = []
	for b in get_overlapping_bodies():
		if b.is_in_group("entities"):
			to_return.append(b)
	return to_return
