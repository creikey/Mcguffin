extends Spatial

func _ready():
	$Player.spawn($Level/Spawnpoint.global_transform)

func _on_Player_death():
	$Player.spawn($Level/Spawnpoint.global_transform)

func _on_FinishLine_player_won(player):
	get_tree().reload_current_scene()


func _on_MailBox_mail_collected():
	get_tree().reload_current_scene()
