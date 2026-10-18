extends Attaché

class_name StrawAttaché

static func create(texture: Resource) -> Attaché:
	var scene = preload("res://scenes/straw_attachment.tscn")
	var instance = scene.instantiate() as StrawAttaché
	return instance

func _ready() -> void:
	
	pass
