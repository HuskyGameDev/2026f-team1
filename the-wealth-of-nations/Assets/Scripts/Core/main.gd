extends CanvasLayer
class_name Main

static var inst : Main

@export var hr_menu : Control
var hr_window : UIWindow

func _ready() -> void:
	inst = self
	hr_window = UIWindow.wrap_in_window("Human Resources", hr_menu)
	add_child(hr_window)
