extends RichTextLabel

var display = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (display):
		visible_ratio += .8*delta


func clearMessage():
	display = false
	visible_ratio = 0
