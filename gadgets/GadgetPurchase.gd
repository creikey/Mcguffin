extends Area

class_name GadgetPurchase

export var scene: PackedScene # must be Gadget
export var price: int

onready var icon_mesh: MeshInstance = $CollisionShape/Button/Icon
onready var icon: Texture = scene.instance().inventory_icon # does this leak memory? probably

func _ready():
#	var price_mat: SpatialMaterial = $CollisionShape/Button/Icon/MeshInstance.material_override
#	price_mat.albedo_texture = ViewportTexture.new()
#	price_mat.albedo_texture.viewport_path = "Viewport"
#	$CollisionShape/Button/Icon/MeshInstance.material_override = price_mat
	
	icon_mesh.material_override = icon_mesh.material_override.duplicate(true)
	var mat: SpatialMaterial = icon_mesh.material_override
	mat.albedo_texture = icon
	$Viewport/PriceLabel.text = "$" + str(price)

func interact(interacter, _interact_point: Vector3):
	interacter.try_purchase(self)
