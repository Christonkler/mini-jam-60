extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Shop Items".close_shop.connect(close_shop)
	pass # Replace with function body.

func close_shop():
	$"Area2D/CollisionShape2D/Shop Background".close_shop()
