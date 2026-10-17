extends VBoxContainer

var enemy_picture_rect : TextureRect
var enemy_description_rect : TextureRect

func _ready():
	enemy_description_rect = $TextureRect2
	enemy_picture_rect = $TextureRect

func make_visible(enemy_picture: Texture2D, enemy_description: Texture2D):
	enemy_picture_rect.texture = enemy_picture
	enemy_description_rect.texture = enemy_description
	self.visible = true
	
func make_invisible() -> void:
	self.visible = false
	
func move_desc(desc_position : String) -> void:
	if desc_position == "Left":
		self.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	elif desc_position == "Right":
		self.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
