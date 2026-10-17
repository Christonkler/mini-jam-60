extends Node2D
class_name Blade

@export_group("Blade Properties")
@export var health: int
@export var weight: float
@export var falling: bool
@export var fysic: RigidBody2D
@export var skin: TextureRect


const MAX_HEALTH = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fysic = $fysic
	skin = $fysic/TextureRect
	fysic.contact_monitor = true
	fysic.max_contacts_reported = 10
	falling = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if falling:
		fysic.linear_velocity = Vector2(0, 0)
		if skin.scale.x > 0 and skin.scale.y > 0:
			skin.scale -= delta / 10 * Vector2(1, 1)
	
func take_damage(damage: int):
	health -= damage

func heal(heal_amount: int):
	health += heal_amount

func resetHealth():
	health = MAX_HEALTH
