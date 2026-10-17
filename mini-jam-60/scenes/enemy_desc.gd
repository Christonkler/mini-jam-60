extends VBoxContainer

var enemy_picture_rect : TextureRect
var enemy_description_rect : TextureRect

func _ready():
	enemy_description_rect = $TextureRect2
	enemy_picture_rect = $TextureRect

func make_visible(enemy_picture: Texture2D, enemy_description: Texture2D):
	enemy_picture_rect.visible = true
	enemy_picture_rect.texture = enemy_picture
	enemy_description_rect.visible = true
	enemy_description_rect.texture = enemy_description
	
func make_invisible() -> void:
	enemy_picture_rect.visible = false
	enemy_description_rect.visible = false
