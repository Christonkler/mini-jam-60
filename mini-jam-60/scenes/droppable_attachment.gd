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
		self.pin_joint.queue_free()
		self.linear_velocity = Vector2(0,0)
