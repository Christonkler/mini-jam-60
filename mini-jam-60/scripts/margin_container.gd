extends MarginContainer

func _ready() -> void:
	self.add_theme_constant_override("margin_left", int(self.size.x / 10))
	self.add_theme_constant_override("margin_right", int(self.size.x / 10))
	self.add_theme_constant_override("margin_top", int(self.size.y / 10))
	self.add_theme_constant_override("margin_bottom", int(self.size.y / 10))
