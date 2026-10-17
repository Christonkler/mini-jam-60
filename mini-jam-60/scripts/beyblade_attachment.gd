extends Node2D
class_name Attaché

signal item_attached

const itemTextures: Array[Resource] = [
	preload("res://assets/Banana Peel.png"),
	preload("res://assets/Apple Core.png"),
	preload("res://assets/Garbage Bag.png"),
	preload("res://assets/Moldy Cheese.png"),
	preload("res://assets/Old Can.png"),
	preload("res://assets/Pistachio.png"),
	preload("res://assets/Wad of Paper.png")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setItem(itemTextures.pick_random())
	
func setItem(texture: Resource):
	$Area2D/CollisionShape2D/TextureRect.set_texture(texture)
