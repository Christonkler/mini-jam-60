extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.visible = false


func displayMatchResultMessage(matchResult: String):
	$TextureRect.visible = true
	if matchResult == "WINNER":
		$TextureRect.texture = preload("res://assets/EndText/victory.png")
	else:
		$TextureRect.texture = preload("res://assets/EndText/defeat.png")
	
