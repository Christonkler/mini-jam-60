extends Attaché
class_name BreakableAttaché

var attached = true

func on_body_entered():
	if attached: 
		attached = false
		self.pin_joint.queue_free()
