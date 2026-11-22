extends Button

@export var calendar_menu : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	calendar_menu.visible = false

func _on_pressed() -> void:
	calendar_menu.visible = !calendar_menu.visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		calendar_menu.visible = false
