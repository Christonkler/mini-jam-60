extends Control

@export var win: bool

# process vars
var start_time: int = 0
var death_time: int = 0
var univ_ctr: Vector2
var hitbox: Area2D
var init_avel: float
var init_avel2: float
var enemy : Blade
var dead_flag: bool = false


func mse(tim: int) -> int:
	return Time.get_ticks_msec() - tim

func d_curve(dist: float) -> float:
	# how does the arena pull force diminish with distance
	var R = 140
	var curve: int
	if dist >= R:
		curve = dist
	else:
		curve = (R - sqrt(R**2 - dist**2))
	return 6 * curve

func pull_mag(blade: RigidBody2D) -> float:
	return d_curve(blade.global_position.distance_to(univ_ctr))

func pull_dir(blade: RigidBody2D) -> Vector2:
	return (univ_ctr - blade.global_position).normalized()

func walk_mag(blade: RigidBody2D) -> float:
	if not randi() % 30:
		return 20 * blade.angular_velocity
	if not randi() % 40:
		return -20 * blade.angular_velocity
	return 0

func walk_dir(blade: RigidBody2D) -> Vector2:
	var ctr_dir: Vector2 = (univ_ctr - blade.global_position).normalized()
	return Vector2(-ctr_dir.y, ctr_dir.x)
	
func apply_pull(blade: RigidBody2D) -> void:
	var blade_parent = blade.get_parent()
	if (blade_parent.name == "PlayerAndAttachedItem"):
		blade_parent = blade_parent.get_parent()
	if not blade_parent.dead:
		blade.apply_central_force(pull_mag(blade) * pull_dir(blade))
		blade.apply_central_force(walk_mag(blade) * walk_dir(blade))

func apply_joik(blade: RigidBody2D, other: RigidBody2D) -> void:
	$SoundEffects.play_collision_sound()
	var outward_dir = (other.global_position - blade.global_position).normalized()
	outward_dir = Vector2.from_angle(outward_dir.angle() + 0.1*(randf()-0.5))
	blade.apply_central_force(20 * abs(blade.angular_velocity) * outward_dir)
	blade.on_body_entered()
	other.on_body_entered()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy == null:
		enemy = $Beyblade2
	else:
		remove_child($Beyblade2)
	start_time = Time.get_ticks_msec()
	hitbox = $TextureRect/Area2D
	$needle.pivot_offset = Vector2(64, 20)
	$needle2.pivot_offset = Vector2(64, 20)
	$PlayerBeyblade.fysic.linear_velocity = Vector2(40, 0)
	enemy.fysic.linear_velocity = Vector2(-40, 0)
	$PlayerBeyblade.fysic.angular_velocity = 50
	enemy.fysic.angular_velocity = 50
	enemy.position = Vector2(84,-93)
	init_avel = $PlayerBeyblade.fysic.angular_velocity
	init_avel2 = enemy.fysic.angular_velocity
	univ_ctr.x = 0
	univ_ctr.y = 0
	for upgrade in Global.upgrades:
		$PlayerBeyblade.fysic.add_child(upgrade)
		$PlayerBeyblade.fysic.setPhysicsForAttachment(upgrade)

func proc_blade(blade: RigidBody2D) -> void:
	apply_pull(blade)
	var blade_parent = blade.get_parent()
	if (blade_parent.name == "PlayerAndAttachedItem"):
		blade_parent = blade_parent.get_parent()

	var others = blade.get_colliding_bodies()
	for other in others:
		if other.get_parent() is Blade:
			apply_joik(blade, other)
	if mse(start_time) > 50 and not hitbox.overlaps_body(blade):
		blade_parent.falling = true
		blade_parent.dead = true
	if blade.angular_velocity < 3:
		blade_parent.dead = true



func _process(delta: float) -> void:
	for child in self.get_children():
		if is_instance_of(child, Blade):
			proc_blade(child.fysic)
			if child.dead:
				dead_flag = true
	$needle.rotation_degrees = -90 * abs($PlayerBeyblade.fysic.angular_velocity / init_avel)
	$needle2.rotation_degrees = 90 + 90 * abs(enemy.fysic.angular_velocity / init_avel2)

	if dead_flag:
		if enemy.dead:
			$MatchResultScreen.displayMatchResultMessage('WINNER')
		else:
			$MatchResultScreen.displayMatchResultMessage('LOSER')
	if dead_flag and not death_time:
		death_time = Time.get_ticks_msec()
	if dead_flag and mse(death_time) > 5000:
		Engine.time_scale = 1 # Resets game speed if fast forwarding
		Global.reset_arena_stuf()
		if enemy.dead:
			get_tree().change_scene_to_file("res://scenes/map.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/mainu.tscn")
			
