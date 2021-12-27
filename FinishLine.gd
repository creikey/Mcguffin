extends Area

signal player_won(player)

var t = 0.0

func _process(delta):
	t += delta
	$MeshInstance.translation.y = sin(t) + 2.0
	$MeshInstance.rotation.y += delta*2.0

func _on_FinishLine_body_entered(body):
	if body.is_in_group("players"):
		emit_signal("player_won", body)
