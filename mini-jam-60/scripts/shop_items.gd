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

var texture_to_scene: Dictionary[String, String] = {
	"res://assets/Banana Peel.png": "res://scenes/banana_peel.tscn",
	"res://assets/Apple Core.png": "res://scenes/apple_core.tscn",
	"res://assets/Garbage Bag.png": "res://scenes/garbage_bag.tscn",
	"res://assets/Moldy Cheese.png": "res://scenes/moldy_cheese.tscn",
	"res://assets/Old Can.png": "res://scenes/old_can.tscn",
	"res://assets/Pistachio.png": "res://scenes/pistachio.tscn",
	"res://assets/Wad of Paper.png": "res://scenes/wad_of_paper.tscn",
	"res://assets/Straw.png": "res://scenes/straw_attachment.tscn"
}

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

		attachment = Attaché.create(texture_to_scene[shopItem.get_child(0).texture_normal.resource_path],shopItem.get_child(0).texture_normal)
		Global.upgrades.append(attachment)
		disableOtherItems(shopItem)
		close_shop.emit()
	pass
	
	
func setRandomItemTexture(textureButton: TextureButton):
	var index = randi() % itemTextures.size()
	textureButton.set_texture_normal(itemTextures.get(index))
	itemTextures.remove_at(index)


func disableOtherItems(shopItem: Node2D):
	for child in get_children():
		if (child != shopItem):
			child.visible = false
