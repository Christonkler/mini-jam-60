extends Panel

func _ready():
	$"MarginContainer/Control".node_visible.connect($"VBoxContainer".make_visible)
	$"MarginContainer/Control".node_invisible.connect($"VBoxContainer".make_invisible)
