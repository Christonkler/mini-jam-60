extends RigidBody2D

var hit = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if (get_colliding_bodies().size() > 0):
		on_body_entered()


func setPhysicsForAttachment(attachment: Attaché):
	# Good enough for a start
	if get_parent().name == "PlayerAndAttachedItem":
		self.get_parent().get_parent().skins.append(attachment.get_child(0).get_child(0).get_child(0))
		get_parent().node_b = attachment.get_path()


# Example function of how to add an attachment to a beyblade. The add child would happen in the shop, and
# we would need to have the necessary attributes of the item added with it
func on_body_entered():

	pass
