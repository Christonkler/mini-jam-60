extends VBoxContainer

var enemy_picture_rect : TextureRect
var enemy_description_rect : RichTextLabel

func _ready():
	enemy_description_rect = get_node("Character Description/MarginContainer/Description")
	enemy_picture_rect = get_node("Character Picture/MarginContainer/Image")

func make_visible(enemy_picture: Texture2D, enemy_description: String):
	enemy_picture_rect.texture = enemy_picture
	enemy_description_rect.text = enemy_description
	self.visible = true
	
func make_invisible() -> void:
	self.visible = false
	
func move_desc(desc_position : String) -> void:
	if desc_position == "Left":
		self.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	elif desc_position == "Right":
		self.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
