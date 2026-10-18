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
@export var dmg: float = 1
@export var bounciness: float = 1
@export var init_vel: int = 40
@export var init_spin: int = 60
@export var pos_mod: Vector2 = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fysic = $fysic
	skins.insert(0, $fysic/TextureRect)
	fysic.contact_monitor = true
	fysic.max_contacts_reported = 10
	falling = false
	dead = false
	match self.scene_file_path:
		"res://scenes/apple.tscn":
			pass
		"res://scenes/car_tire.tscn":
			self.friction = 1.5
		"res://scenes/inception_top.tscn":
			pos_mod = Vector2(-90, 90)
			init_spin = 100
			dmg = 2
		"res://scenes/gem.tscn":
			pass
		"res://scenes/scooter_wheel.tscn":
			self.bounciness = 1.5
		"res://scenes/pineapple.tscn":
			pass

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
