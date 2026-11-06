extends Button
@export var rnd_menu : Control

func _ready() -> void:
	rnd_menu.visible = false
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	rnd_menu.visible = !rnd_menu.visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		EventBus.emit_signal("exitTreeDocument")
		rnd_menu.visible = false
