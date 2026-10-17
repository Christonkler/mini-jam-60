extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.visible = false


func displayMatchResultMessage(matchResult: String):
	$RichTextLabel.visible = true
	$RichTextLabel.text = matchResult
