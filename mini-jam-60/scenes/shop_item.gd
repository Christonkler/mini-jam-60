extends Node2D

signal item_purchase_request(Node2D)
signal purchase_complete


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var textureButton = $TextureButton
	
	textureButton.button_down.connect(purchaseItemRequest)
	
	
func purchaseItemRequest():
	item_purchase_request.emit()
	await get_tree().create_timer(1.8).timeout
	get_tree().change_scene_to_file("res://scenes/mainu.tscn")

func purchaseItem():
	print("item purchased")
	purchase_complete.emit()
