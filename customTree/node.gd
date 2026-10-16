extends GraphNode

@export var line: PackedScene
@export var data: Dictionary = {}
@export var lineArr := []
@export var nodeSet := {}
@export var doc := {}
@onready var subtitle := $Subtitle

func _on_tree_entered() -> void:
	title = data.get("name", "Unnamed Node")
	doc.merge(data.get("document", {}))
	data.set("children", [])
	data.set("parents", [])
	resize()

func _ready() -> void:
	subtitle.text = data.get("subtitle", "")
	resize()

func resize():
	if(data.has("pos")):
		position_offset = Vector2(data["pos"][0], data["pos"][1])
	if(data.has("dim")):
		size = Vector2(data["dim"][0], data["dim"][1])

func parentOf(connection: Array):
	var child = connection[1]
	var currline = line.instantiate()
	lineArr.append(currline)
	currline.parentName = title
	currline.childName = child
	data["children"].append(child)
	nodeSet[child].data["parents"].append(connection[0])
	add_child(currline)
