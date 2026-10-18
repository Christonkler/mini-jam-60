extends PinJoint2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (get_node(node_b) != null):
		get_node(node_b).angular_velocity = $fysic.angular_velocity
	
func add_attachment(attachment: RigidBody2D):
	self.node_b = attachment.get_path()
