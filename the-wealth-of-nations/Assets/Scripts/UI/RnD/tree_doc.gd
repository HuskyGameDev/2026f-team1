extends ColorRect

var nodeSet := {}

@onready var title := $Margins/VBox/Title
@onready var image := $Margins/VBox/Image
@onready var text := $Margins/VBox/Text
@onready var buy := $Margins/VBox/Button/Buy

func _init() -> void:
	EventBus.connect("pushTreeDocument", pushTreeDocument)
	EventBus.connect("exitTreeDocument", exitTreeDocument)
	EventBus.connect("submitNodeSet", setNodeData)

func setNodeData(dict: Dictionary):
	nodeSet = dict

func pushTreeDocument(id: String):
	if(!nodeSet.has(id)): return
	var node = nodeSet[id]
	if(node.doc.is_empty()): return
	var nodeData: Dictionary = node.data
	var doc: Dictionary = node.doc
	title.text = doc.get("header", "UNAMED")
	if(title.text == "@name"): title.text = nodeData["name"]
	image.texture = ImageTexture.create_from_image(Image.load_from_file(doc.get("image", "res://icon.svg")))
	text.text = "\n".join(doc.get("text", ["EMPTY"]))

func exitTreeDocument():
	pass

func _on_button_pressed() -> void:
	buy.play()
