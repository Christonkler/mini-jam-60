extends TextureRect

func _ready():
	$"MarginContainer/Control".node_visible.connect($"VBoxContainer".make_visible)
	$"MarginContainer/Control".node_invisible.connect($"VBoxContainer".make_invisible)
	$"MarginContainer/Control".move_desc.connect($"VBoxContainer".move_desc)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainu.tscn")

func _on_control_end_game() -> void:
	$TextureRect.visible = true
