extends Node2D

signal shop_closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Shop Items".close_shop.connect(close_shop)


func close_shop():
	$"Area2D/CollisionShape2D/Shop Background".close_shop()
	shop_closed.emit()
	#get_tree().change_scene_to_file("res://scenes/mainu.tscn")
