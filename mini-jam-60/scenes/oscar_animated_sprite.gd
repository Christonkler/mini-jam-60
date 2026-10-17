extends AnimatedSprite2D

signal oscar_flies

const OSCAR_BUG_LIMIT = 1
var oscar_bugged_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureButton.button_down.connect(bugOscar)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bugOscar():
	oscar_bugged_count += 1
	
	if (oscar_bugged_count >= OSCAR_BUG_LIMIT):
		oscar_flies.emit()
