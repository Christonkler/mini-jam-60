extends AnimatedSprite2D

var velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Rocket Flames".visible = false
	animation_finished.connect(revealFlames)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset.y -= velocity*delta
	$"Rocket Flames".offset.y -= velocity*delta

func revealFlames():
	$"Rocket Flames".visible = true
	$"Rocket Flames".play()
	velocity = 150
