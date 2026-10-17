extends Node2D

signal item_purchase_request(Node2D)
signal purchase_complete


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var textureButton = $TextureButton
	
	textureButton.button_down.connect(purchaseItemRequest)
	
	
func purchaseItemRequest():
	item_purchase_request.emit()

func purchaseItem():
	print("item purchased")
	purchase_complete.emit()
