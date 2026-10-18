extends Attaché
class_name BreakableAttaché

var attached = true

func on_body_entered():
	if attached: 
		attached = false
		var fysic = self.get_parent()
		var pinJoin = fysic.get_parent()
		fysic.reparent(pinJoin.get_parent())
		pinJoin.queue_free()
