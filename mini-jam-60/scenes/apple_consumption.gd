extends AnimatedSprite2D

func load_next_frame() -> void:
	self.set_frame_and_progress(self.frame+1, 0)
