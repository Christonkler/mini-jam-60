extends Node2D
class_name Attaché

signal item_attached

#const itemTextures: Array[Resource] = [
	#preload("res://assets/Banana Peel.png"),
	#preload("res://assets/Apple Core.png"),
	#preload("res://assets/Garbage Bag.png"),
	#preload("res://assets/Moldy Cheese.png"),
	#preload("res://assets/Old Can.png"),
	#preload("res://assets/Pistachio.png"),
	#preload("res://assets/Wad of Paper.png")
#]
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
