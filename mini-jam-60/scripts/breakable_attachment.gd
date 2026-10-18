extends Attaché
class_name BreakableAttaché

var attached = true

func on_body_entered():
	if attached: 
		attached = false
		$SoundEffects.play_break_sound()
		self.pin_joint.queue_free()
