extends Node

signal close_shop

var itemTextures: Array[Resource] = [
	preload("res://assets/Banana Peel.png"),
	preload("res://assets/Apple Core.png"),
	preload("res://assets/Garbage Bag.png"),
	preload("res://assets/Moldy Cheese.png"),
	preload("res://assets/Old Can.png"),
	preload("res://assets/Pistachio.png"),
	preload("res://assets/Wad of Paper.png"),
	preload("res://assets/Straw.png")
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
		var attachment: Attaché
#		TODO: Check this in a better way
		if shopItem.get_child(0).texture_normal.resource_path == "res://assets/Straw.png":
			attachment = StrawAttaché.create(shopItem.get_child(0).texture_normal)
		else:
			attachment = Attaché.create(shopItem.get_child(0).texture_normal)
		Global.upgrades.append(attachment)
		close_shop.emit()
	pass
	
	
func setRandomItemTexture(textureButton: TextureButton):
	var index = randi() % itemTextures.size()
	textureButton.set_texture_normal(itemTextures.get(index))
	itemTextures.remove_at(index)
