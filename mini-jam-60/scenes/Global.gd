extends Node

@export var upgrades: Array[Attaché] = []
@export var top: String = "can lid"

func reset_arena_stuf() -> void:
	var reset_upgrades : Array[Attaché]
	for upgrade in upgrades:
		reset_upgrades.append(upgrade.reset())
	upgrades = reset_upgrades
