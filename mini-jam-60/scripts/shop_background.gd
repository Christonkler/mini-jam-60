extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func close_shop():
	$"Oscar's Intro".clear()
	$"Oscar's Outro".writeMessage()
	$"Oscar Animated Sprite".play_backwards("oscar_greeting")
