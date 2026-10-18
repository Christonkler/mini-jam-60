extends AnimatedSprite2D

var velocity = 0
var rocket_sound_timer = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Rocket Flames".visible = false
	animation_finished.connect(revealFlames)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rocket_sound_timer > -1:
		rocket_sound_timer += delta
	if rocket_sound_timer > 1.6:
		$AudioStreamPlayer.stop()
		rocket_sound_timer = -1
	offset.y -= velocity*delta
	$"Rocket Flames".offset.y -= velocity*delta

func revealFlames():
	rocket_sound_timer = 0
	$"Rocket Flames".visible = true
	$"Rocket Flames".play()
	$AudioStreamPlayer.play(0.3)
	velocity = 150
