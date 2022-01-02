extends Area

signal mail_collected

func _on_MailBox_body_entered(body):
	if body.is_in_group("players") and body.has_mail:
		emit_signal("mail_collected")
