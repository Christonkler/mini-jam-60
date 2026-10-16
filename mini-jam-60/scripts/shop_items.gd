extends Node

signal close_shop

var itemTextures: Array[Resource] = [
	preload("res://assets/Banana Peel.png"),
	preload("res://assets/Apple Core.png"),
	preload("res://assets/Garbage Bag.png"),
	preload("res://assets/Moldy Cheese.png"),
	preload("res://assets/Old Can.png"),
	preload("res://assets/Pistachio.png"),
	preload("res://assets/Wad of Paper.png")
]

var item_purchased = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ShopItem.item_purchase_request.connect(purchaseItem.bind($ShopItem))
	$ShopItem2.item_purchase_request.connect(purchaseItem.bind($ShopItem2))
	$ShopItem3.item_purchase_request.connect(purchaseItem.bind($ShopItem3))
	
	setRandomItemTexture($ShopItem/TextureButton)
	setRandomItemTexture($ShopItem2/TextureButton)
	setRandomItemTexture($ShopItem3/TextureButton)
	pass # Replace with function body.

func purchaseItem(shopItem: Node2D):
	if (not item_purchased):
		item_purchased = true
		shopItem.purchaseItem()
		close_shop.emit()
	pass
	
	
func setRandomItemTexture(textureButton: TextureButton):
	var index = randi() % itemTextures.size()
	var texture = itemTextures.get(index)
	textureButton.set_texture_normal(texture)
	itemTextures.remove_at(index)
