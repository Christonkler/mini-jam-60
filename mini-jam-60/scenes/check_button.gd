extends TextureButton

signal item_purchased

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		item_purchased.emit()
		
