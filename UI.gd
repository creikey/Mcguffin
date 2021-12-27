extends CanvasLayer

onready var player = $"../Player"

onready var money = $MoneyLabel

func _process(_delta):
	money.text = "$" + str(player.money)

func _on_Player_toolbelt_changed():
	var c: int = 0
	while c < $GadgetInventory.get_child_count():
		var child = $GadgetInventory.get_child(c)
		var gadget: Gadget = null
		if c < non_deleting_toolbelt().size():
			gadget = non_deleting_toolbelt()[c]
		if gadget != null and not gadget.is_queued_for_deletion():
			child.set_as(gadget.inventory_icon)
			if player.activated_gadget == gadget:
				child.activate()
		else:
			child.set_as(null)
		c += 1

func non_deleting_toolbelt() -> Array:
	var to_return = []
	for c in player.toolbelt.get_children():
		if not c.is_queued_for_deletion():
			to_return.append(c)
	return to_return
