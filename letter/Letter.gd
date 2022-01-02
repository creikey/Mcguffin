extends Area


var t := 0.0
func _process(delta):
	t += delta
	$letter.translation.y = sin(t*2.0)*1.5
	$letter.rotation.y += delta*PI

func _on_Letter_body_entered(body):
	if body.is_in_group("players") and not body.has_mail:
		body.has_mail = true
		$AudioStreamPlayer3D.play()
