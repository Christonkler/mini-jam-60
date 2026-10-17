extends RichTextLabel

var display = false

const messages: Array[String] = [
	"Don’t worry sweetie, you’re treasure to me",
	"I hate Sesame Street",
	"Not what I would've picked",
	"I have one just like that in my can",
	"Bring that back when you're done\n    with it"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (display):
		visible_ratio += .8*delta

func writeMessage():
	text = messages.pick_random()
	display = true
