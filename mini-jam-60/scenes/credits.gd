extends TextureRect


func _input(event: InputEvent) -> void:
	if event.is_pressed():
		visible = false
