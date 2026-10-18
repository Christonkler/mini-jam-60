extends Node

@export var upgrades: Array[Attaché] = []

func reset_arena_stuf() -> void:
	var reset_upgrades : Array[Attaché]
	for upgrade in upgrades:
		reset_upgrades.append(upgrade.reset())
	upgrades = reset_upgrades
