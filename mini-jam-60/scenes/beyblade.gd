extends Node2D

@export_group("Blade Properties")
@export var health: int
@export var weight: float


const MAX_HEALTH = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage(damage: int):
	health -= damage

func heal(heal_amount: int):
	health += heal_amount

func resetHealth():
	health = MAX_HEALTH
