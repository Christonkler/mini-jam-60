extends RigidBody2D

var hit = false
var last_hit = 0
var upgrades : Array[Attaché]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if (get_colliding_bodies().size() > 0):
		on_body_entered()

func add_upgrade(attachment: Attaché):
	# Good enough for a start
	upgrades.append(attachment)
		
func disable_collision():
	$"CollisionShape2D".disabled=true

# Example function of how to add an attachment to a beyblade. The add child would happen in the shop, and
# we would need to have the necessary attributes of the item added with it
func on_body_entered():
	if get_node_or_null("AnimatedSprite2D"):
		$"AnimatedSprite2D".load_next_frame()
	
	for node in get_children():
		if is_instance_of(node, BreakableAttaché):
			node.on_body_entered()
	pass
