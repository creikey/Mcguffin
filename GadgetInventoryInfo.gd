extends Control

func set_as(icon: Texture):
	deactivate()
	if icon != null:
		$Frame/Icon.texture = icon
	else:
		$Frame/Icon.texture = null

func activate():
	$ActivatedColorRect.visible = true

func deactivate():
	$ActivatedColorRect.visible = false
