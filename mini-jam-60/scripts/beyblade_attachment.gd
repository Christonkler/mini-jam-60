extends Node2D
class_name Attaché

signal item_attached

var use_this_texture: Resource


static func create(texture: Resource) -> Attaché:
	var scene = preload("res://scenes/beyblade_attachment.tscn")
	var instance = scene.instantiate() as Attaché
	instance.use_this_texture = texture
	return instance

func _ready() -> void:
	setItem(use_this_texture)
	
func setItem(texture: Resource):
	$Area2D/CollisionShape2D/TextureRect.set_texture(texture)
