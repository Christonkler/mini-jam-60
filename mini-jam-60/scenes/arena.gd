extends Control

@export var win: bool

# process vars
var fysic_1: RigidBody2D
var fysic_2: RigidBody2D
var push_temp: Vector2
var univ_ctr: Vector2


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
	# find our blades
	fysic_1 = $Beyblade.fysic
	fysic_2 = $Beyblade2.fysic
	push_temp.x = -30
	push_temp.y = 0
	fysic_1.set_axis_velocity(push_temp)
	push_temp.x = 30
	push_temp.y = 0
	fysic_2.set_axis_velocity(push_temp)
	univ_ctr.x = 0
	univ_ctr.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apply_pull(fysic_1)
	fysic_1.apply_torque(30000 * delta)
	apply_pull(fysic_2)
	fysic_2.apply_torque(30000 * delta)
