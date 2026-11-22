extends PanelContainer

@export var indicator_scene : PackedScene
@export var indicator_container : Container

func _ready() -> void:
	for i in Enums.GameResource.size():
		var new : ResourceIndicator = indicator_scene.instantiate()
		new.bound_resource = i as Enums.GameResource
		indicator_container.add_child(new)
