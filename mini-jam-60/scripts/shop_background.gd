extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Oscar Rocket".visible = false
	$"Oscar Animated Sprite".oscar_flies.connect(oscarFlies)

func close_shop():
	#if ()
	$"Oscar's Intro".clear()
	$"Oscar's Outro".writeMessage()
	$"Oscar Animated Sprite".play_backwards("oscar_greeting")

func oscarFlies():
	$"Oscar Animated Sprite".play_backwards("oscar_greeting")
	# TODO: Wait to launch the rocket until the animation ends
	$"Oscar's Intro".clear()
	$"Oscar Animated Sprite".visible = false
	$"Oscar Rocket".visible = true
	$"Oscar Rocket".play("default")
