extends CanvasLayer
class_name Main

static var inst : Main

@export var hr_menu : Control
@export var stockpile_menu : Control
@export var region_menu : RegionMenu # Needs to be specifically typed so we can give it a pointer to its window

var hr_window : UIWindow
var stockpile_window : UIWindow
var region_window : UIWindow

@export var hr_taskbar_button : TaskbarButton
@export var stockpile_taskbar_button : TaskbarButton

func _ready() -> void:
	inst = self
	hr_window = UIWindow.wrap_in_window("Human Resources", hr_menu)
	stockpile_window = UIWindow.wrap_in_window("Stockpile Monitor", stockpile_menu)
	region_window = UIWindow.wrap_in_window("Regional Report: Ya Mom's House", region_menu)
	
	add_child(hr_window)
	add_child(stockpile_window)
	add_child(region_window)
	
	hr_taskbar_button.bound_window = hr_window
	stockpile_taskbar_button.bound_window = stockpile_window
	region_menu.window = region_window

# Close all windows if you press escape
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hr_window.is_open = false
		stockpile_window.is_open = false
		region_window.is_open = false

static func open_region(reg : Enums.Region) -> void: ## An easier way to call open_region on the region menu
	inst.region_menu.open_region(reg)
