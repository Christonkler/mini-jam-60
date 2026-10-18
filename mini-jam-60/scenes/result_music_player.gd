extends AudioStreamPlayer2D

const victory_music = preload("res://assets/music/28. Short Lived Victory - Trent Zulkiewicz.wav")
const failure_music = preload("res://assets/music/12. Let_s Roll - Droodle.wav")


func play_results_music(player_won: bool):
	if player_won:
		self.stream = victory_music
		self.play(0.25)
	else:
		self.stream = failure_music
		self.play(1.4)
