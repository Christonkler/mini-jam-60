extends Node2D
class_name Blade

@export_group("Blade Properties")
@export var health: int
@export var weight: float
@export var falling: bool
@export var dead: bool
@export var fysic: RigidBody2D
@export var skins: Array[TextureRect] = []
var death_pos: Array[Vector2] = []
var death_vcs: Array[Vector2] = []


const MAX_HEALTH = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fysic = $fysic
	skins.insert(0, $fysic/TextureRect)
	fysic.contact_monitor = true
	fysic.max_contacts_reported = 10
	falling = false
	dead = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dead:
		if not death_pos:  # on first frame of death, grab some info
			for skin in skins:
				death_pos.append(skin.global_position)
				death_vcs.append(0.07 * fysic.linear_velocity + Vector2(30 * (randf()-0.5), 30 * (randf()-0.5)))
		for i in range(1, len(skins)):  # fun death animation
			death_pos[i] += delta * death_vcs[i]
			skins[i].global_position = death_pos[i]
	if falling:
		fysic.linear_velocity = Vector2(0, 0)
		for skin in skins:
			if skin.scale.x > 0 and skin.scale.y > 0:
				skin.scale -= delta / 5 * Vector2(1, 1)
	
func take_damage(damage: int):
	health -= damage

func heal(heal_amount: int):
	health += heal_amount

func resetHealth():
	health = MAX_HEALTH
