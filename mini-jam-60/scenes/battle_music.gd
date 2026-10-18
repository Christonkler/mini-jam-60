extends AudioStreamPlayer

const battle_music: Array[Resource] = [
	preload("res://assets/music/battle.wav"),
	preload("res://assets/music/cosmicbattle.wav")
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = battle_music.pick_random()
	play()
