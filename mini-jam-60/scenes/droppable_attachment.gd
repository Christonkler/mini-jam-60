extends Attaché

class_name DroppableAttaché

var attached = true

func _unhandled_input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		self.drop()

func drop():
	if attached and get_tree().current_scene.get_node("/root/Arena/Control").launched: 
		attached = false
		get_tree().current_scene.get_node("/root/Arena/Control").immune_start = Time.get_ticks_msec()
		var fysic = self.get_parent()
		var pinJoin = fysic.get_parent()
		fysic.call_deferred("reparent", pinJoin.get_parent())
		pinJoin.call_deferred("queue_free")
		self.linear_velocity = Vector2(0,0)
