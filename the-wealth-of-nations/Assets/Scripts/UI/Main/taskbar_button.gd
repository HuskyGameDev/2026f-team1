extends Button
class_name TaskbarButton

@export var bound_window : UIWindow

func _pressed() -> void:
	bound_window.is_open = !bound_window.is_open
