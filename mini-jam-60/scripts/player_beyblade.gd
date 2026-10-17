extends "res://scenes/beyblade.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fysic = $PlayerAndAttachedItem/fysic
	skins.insert(0, $PlayerAndAttachedItem/fysic/TextureRect)
	fysic.contact_monitor = true
	fysic.max_contacts_reported = 10
	falling = false
	dead = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
