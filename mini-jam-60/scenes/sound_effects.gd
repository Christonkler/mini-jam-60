extends AudioStreamPlayer2D

const sounds: Array[Resource] = [
	preload("res://assets/audio/clang1.mp3"),
	preload("res://assets/audio/clang3.mp3"),
	preload("res://assets/audio/clang4.mp3"),
	preload("res://assets/audio/clang5.mp3"),
	preload("res://assets/audio/clang6.mp3"),
]


func play_collision_sound():
	var sound = sounds.pick_random()
	stream = sound
	play()
