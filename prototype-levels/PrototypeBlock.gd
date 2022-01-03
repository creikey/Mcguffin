extends StaticBody

func to_shape(width: float, height: float, depth: float):
	var shape: BoxShape = $CollisionShape.shape.duplicate(true)
	shape.extents.x = width
	shape.extents.y = height
	shape.extents.z = depth
	shape.extents /= 2.0
	$CollisionShape.shape = shape
	var mesh: CubeMesh = $MeshInstance.mesh.duplicate(true)
	mesh.size.x = width
	mesh.size.y = height
	mesh.size.z = depth
	$MeshInstance.mesh = mesh
