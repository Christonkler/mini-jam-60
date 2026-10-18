extends AudioStreamPlayer2D

const sounds: Array[Resource] = [
	preload("res://assets/audio/clang1.mp3"),
	preload("res://assets/audio/clang3.mp3"),
	preload("res://assets/audio/clang4.mp3"),
	preload("res://assets/audio/clang5.mp3"),
	preload("res://assets/audio/clang6.mp3"),
]

const break_sounds: Array[Resource] = [
	preload("res://assets/audio/break1.mp3"),
	preload("res://assets/audio/break2.mp3"),
	preload("res://assets/audio/break3.mp3"),
	preload("res://assets/audio/break4.mp3"),
	preload("res://assets/audio/break5.mp3")
]

func play_collision_sound():
	var sound = sounds.pick_random()
	stream = sound
	play()

func play_break_sound():
	var sound = break_sounds.pick_random()
	stream = sound
	play()
