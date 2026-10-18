extends RigidBody2D
class_name Attaché

var use_this_texture: Resource


static func create(scene_to_load: String, texture: Resource) -> Attaché:
	var scene = load(scene_to_load)
	var instance = scene.instantiate() as Attaché
	instance.use_this_texture = texture
	return instance

func _ready() -> void:
	pass
	
func on_collision() -> void:
	pass
	
