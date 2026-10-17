extends TextureButton

var speed_up = false



func _on_pressed() -> void:
	speed_up = not speed_up
	if speed_up:
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1
