extends CanvasLayer
class_name Main

static var inst : Main

@export var hr_menu : Control
@export var stockpile_menu : Control

var hr_window : UIWindow
var stockpile_window : UIWindow

@export var hr_taskbar_button : TaskbarButton
@export var stockpile_taskbar_button : TaskbarButton

func _ready() -> void:
	inst = self
	hr_window = UIWindow.wrap_in_window("Human Resources", hr_menu)
	stockpile_window = UIWindow.wrap_in_window("Stockpile Monitor", stockpile_menu)
	add_child(hr_window)
	add_child(stockpile_window)
	
	hr_taskbar_button.bound_window = hr_window
	stockpile_taskbar_button.bound_window = stockpile_window

# Close all windows if you press escape
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hr_window.is_open = false
		stockpile_window.is_open = false
