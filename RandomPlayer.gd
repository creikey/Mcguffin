extends Node

export (Array, AudioStream) var sounds
export var is_spatial: bool = true
export var random_pitch_range = [1.0, 1.0]

func _ready():
	randomize()

func play():
	var new = null
	if is_spatial:
		new = AudioStreamPlayer3D.new()
	else:
		new = AudioStreamPlayer.new()
	add_child(new)
	new.stream = sounds[randi()%sounds.size()]
	new.pitch_scale = rand_range(random_pitch_range[0], random_pitch_range[1])
	new.play()
	new.connect("finished", self, "_on_player_finished", [new])

func _on_player_finished(player):
	player.queue_free()
