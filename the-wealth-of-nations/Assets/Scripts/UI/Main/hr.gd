extends Button
@export var hr_menu : Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)

# Connected in ready, so this method calls every time the button is fully pressed (pressed down and released by default)
func _on_pressed() -> void:
	Main.inst.hr_window.is_open = !Main.inst.hr_window.is_open

# Close menu if you press escape
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Main.inst.hr_window.is_open = false
