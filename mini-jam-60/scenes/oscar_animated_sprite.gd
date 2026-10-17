extends AnimatedSprite2D

signal oscar_flies

const OSCAR_BUG_LIMIT = 1
var oscar_bugged_count = 0

func _ready() -> void:
	$TextureButton.button_down.connect(bugOscar)

func bugOscar():
	oscar_bugged_count += 1
	
	if (oscar_bugged_count >= OSCAR_BUG_LIMIT):
		oscar_flies.emit()
