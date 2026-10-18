extends RigidBody2D
class_name Attaché

var use_this_texture: Resource
var scene_str : String
var pin_joint : PinJoint2D

static func create(scene_to_load: String, texture: Resource) -> Attaché:
	var scene = load(scene_to_load)
	var instance = scene.instantiate() as Attaché
	instance.use_this_texture = texture
	instance.scene_str = scene_to_load
	return instance

func reset() -> Attaché:
	return create(scene_str, use_this_texture)

func _ready() -> void:
	pass
	
func on_collision() -> void:
	pass
	
