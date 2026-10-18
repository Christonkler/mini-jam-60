extends TextureRect

func _ready() -> void:
	var textureButton = $TextureButton
	textureButton.button_up.connect(press_button)

func press_button():
	var labl: Label = self.get_child(0)
	var txt: String = labl.text
	if txt == "LET IT RIP":
		if FileAccess.file_exists("user://map_data.res"):
			DirAccess.remove_absolute("user://map_data.res")
		Global.upgrades = []
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	elif txt == "CREDITS":
		$"../Credits".visible = true
	elif txt == "QUIT":
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
