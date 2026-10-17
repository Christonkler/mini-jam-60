extends Control

@export var win: bool

# process vars
var start_time: int = 0
var death_time: int = 0
var univ_ctr: Vector2
var hitbox: Area2D


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
	return 4 * curve

func pull_mag(blade: RigidBody2D) -> float:
	return d_curve(blade.global_position.distance_to(univ_ctr))

func pull_dir(blade: RigidBody2D) -> Vector2:
	return (univ_ctr - blade.global_position).normalized()

func walk_mag(blade: RigidBody2D) -> float:
	if not randi() % 30:
		return 30 * blade.angular_velocity
	return 0

func walk_dir(blade: RigidBody2D) -> Vector2:
	var ctr_dir: Vector2 = (univ_ctr - blade.global_position).normalized()
	return Vector2(-ctr_dir.y, ctr_dir.x)
	
func apply_pull(blade: RigidBody2D) -> void:
	if not blade.dead:
		blade.apply_central_force(pull_mag(blade) * pull_dir(blade))
		blade.apply_central_force(walk_mag(blade) * walk_dir(blade))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_time = Time.get_ticks_msec()
	hitbox = $TextureRect/Area2D
	$Beyblade.fysic.linear_velocity = Vector2(80, 0)
	$Beyblade2.fysic.linear_velocity = Vector2(-80, 0)
	$Beyblade.fysic.angular_velocity = 50
	$Beyblade2.fysic.angular_velocity = 50
	univ_ctr.x = 0
	univ_ctr.y = 0
	for upgrade in Global.upgrades:
		$Beyblade.fysic.add_child(upgrade)
		$Beyblade.fysic.setPhysicsForAttachment(upgrade)


func proc_blade(blade: RigidBody2D) -> void:
	apply_pull(blade)
	if mse(start_time) > 50 and not hitbox.overlaps_body(blade):
		blade.get_parent().falling = true
		blade.get_parent().dead = true
	if blade.angular_velocity < 3:
		blade.get_parent().dead = true
		


func _process(delta: float) -> void:
	var dead_flag: bool = false
	for child in self.get_children():
		if is_instance_of(child, Blade):
			proc_blade(child.fysic)
			if child.dead:
				if not dead_flag and child.name == "Beyblade":
					$MatchResultScreen.displayMatchResultMessage('LOSER')
				elif not dead_flag:
					$MatchResultScreen.displayMatchResultMessage('WINNER')
				dead_flag = true

	if dead_flag and not death_time:
		death_time = Time.get_ticks_msec()
	if dead_flag and mse(death_time) > 5000:
		Engine.time_scale = 1 # Resets game speed if fast forwarding
		get_tree().change_scene_to_file("res://scenes/map.tscn")
