extends Button
# This carp variable IS the carp image. It Like that is what it is in it's entirety. 
@onready var humanResources = %HumanResources
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	humanResources.visible = false
	pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# I will endeavor to find out what this does later. It was in the guide. 
func _on_pressed() -> void:
	humanResources.visible = not humanResources.visible
	
# Close image if you press escape
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		humanResources.visible = false
		
