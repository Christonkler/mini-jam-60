extends AnimatedSprite2D

var more_frames : bool = true
var last_hit : int
const MSECS_BETWEEN_HIT = 100

func _ready() -> void:
	self.stop()

func load_next_frame() -> void:
	var system_time = Time.get_ticks_msec()
	if more_frames and system_time - MSECS_BETWEEN_HIT > last_hit:
		self.frame = self.frame + 1
		last_hit = system_time

func _on_animation_finished() -> void:
	more_frames = false
