extends TextureRect

func _ready() -> void:
	var textureButton = $TextureButton
	textureButton.button_up.connect(press_button)

func press_button():
	var labl: Label = self.get_child(0)
	var txt: String = labl.text
	if txt == "LET IT RIP":
		if FileAccess.file_exists("user://savegame.save"):
			DirAccess.remove_absolute("user://savegame.save")
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	elif txt == "SETTINGS":
		get_tree().change_scene_to_file("res://scenes/shop.tscn")
	elif txt == "QUIT":
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
