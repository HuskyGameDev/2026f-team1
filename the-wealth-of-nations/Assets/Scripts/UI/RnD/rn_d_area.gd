extends Control

@onready var doc := $TreeDoc


func _ready() -> void:
	doc.visible = false
	EventBus.connect("pushTreeDocument", pushTreeDocument)
	EventBus.connect("exitTreeDocument", exitTreeDocument)

func pushTreeDocument(_id: String):
	doc.visible = true

func exitTreeDocument():
	doc.visible = false
