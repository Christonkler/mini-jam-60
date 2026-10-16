extends Node2D

@export_group("Blade Properties")
@export var health: int
@export var weight: float
@export var fysic: RigidBody2D


const MAX_HEALTH = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fysic = self.get_child(0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage(damage: int):
	health -= damage

func heal(heal_amount: int):
	health += heal_amount

func resetHealth():
	health = MAX_HEALTH
