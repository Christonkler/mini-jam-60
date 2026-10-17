extends TextureRect

var write_goodbye_message = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Oscar Rocket".visible = false
	$"Oscar Animated Sprite".oscar_flies.connect(oscarFlies)

func close_shop():
	# NOTE: The shop still waits to exit after Oscar leaves
	if (write_goodbye_message):
		$"Oscar's Intro".clear()
		$"Oscar's Outro".writeMessage("")
		$"Oscar Animated Sprite".play_backwards("oscar_greeting")

func oscarFlies():
	$"Oscar Animated Sprite".play_backwards("oscar_greeting")
	write_goodbye_message = false
	$"Oscar's Intro".clear()
	$"Oscar Animated Sprite".visible = false
	$"Oscar Rocket".visible = true
	$"Oscar's Outro".writeMessage("I don't want to live on this planet\n     anymore")
	$"Oscar Rocket".play("default")
