extends Button
@onready var carp = %LongIslandCarp
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	carp.visible = false
	pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	carp.visible = not carp.visible
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		carp.visible = false
		
