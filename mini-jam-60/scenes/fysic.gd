extends RigidBody2D

var hit = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setPhysicsForAttachments()
	
func _process(delta: float) -> void:
	if (get_colliding_bodies().size() > 0):
		on_body_entered()


func setPhysicsForAttachments():
	# This gets all Beyblade attachment children. Kinda janky since it relies on there being no other nodes
	# Good enough for a start
	for i in range(2, get_children().size()):
		var children = get_children()
		children[2].get_child(0).get_child(0).reparent(self)
	
	#$BeybladeAttachment.get_child(0).get_child(0).reparent(self)


# Example function of how to add an attachment to a beyblade. The add child would happen in the shop, and
# we would need to have the necessary attributes of the item added with it
func on_body_entered():
	if not hit:
		print("Collision")
		var attachment = load("res://scenes/beyblade_attachment.tscn").instantiate()
		self.add_child(attachment)
		setPhysicsForAttachments()
		hit = true
	pass
