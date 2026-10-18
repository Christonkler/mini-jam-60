extends RigidBody2D
class_name Attaché

var use_this_texture: Resource
var scene_str : String
var pin_joint : PinJoint2D
var falling: bool = false

static func create(scene_to_load: String, texture: Resource) -> Attaché:
	var scene = load(scene_to_load)
	var instance = scene.instantiate() as Attaché
	instance.use_this_texture = texture
	instance.scene_str = scene_to_load
	return instance
	
func disable_collision():
	$"CollisionShape2D".disabled=true

func reset() -> Attaché:
	return create(scene_str, use_this_texture)

func _ready() -> void:
	pass
	
func on_collision() -> void:
	pass
	
func _process(delta: float) -> void:
	if falling:
		self.linear_velocity = Vector2(0, 0)
		if $"CollisionShape2D/TextureRect".scale.x > 0 and $"CollisionShape2D/TextureRect".scale.y > 0:
			$"CollisionShape2D/TextureRect".scale -= delta / 5 * Vector2(1, 1)
