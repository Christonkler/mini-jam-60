extends Control

@export var win: bool

# process vars
var start_time: int
var univ_ctr: Vector2
var hitbox: Area2D


func ms_elapsed() -> int:
	return Time.get_ticks_msec() - start_time

func d_curve(dist: float) -> float:
	# how does the arena pull force diminish with distance
	return dist

func pull_mag(blade: RigidBody2D) -> float:
	return d_curve(blade.global_position.distance_to(univ_ctr))

func pull_dir(blade: RigidBody2D) -> Vector2:
	return (univ_ctr - blade.global_position).normalized()
	
func apply_pull(blade: RigidBody2D) -> void:
	blade.apply_central_force(pull_mag(blade) * pull_dir(blade))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_time = Time.get_ticks_msec()
	hitbox = $TextureRect/Area2D
	$Beyblade.fysic.linear_velocity = Vector2(300, 0)
	$Beyblade2.fysic.linear_velocity = Vector2(30, 0)
	univ_ctr.x = 0
	univ_ctr.y = 0
	for upgrade in Global.upgrades:
		$Beyblade.fysic.add_child(upgrade)
		$Beyblade.fysic.setPhysicsForAttachment(upgrade)


func proc_blade(blade: RigidBody2D) -> void:
	apply_pull(blade)
	if ms_elapsed() > 50 and not hitbox.overlaps_body(blade):
		blade.get_parent().falling = true
		blade.get_parent().dead = true


func _process(delta: float) -> void:
	for child in self.get_children():
		if is_instance_of(child, Blade):
			child.fysic.apply_torque(30000 * delta)
			proc_blade(child.fysic)
