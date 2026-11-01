extends MarginContainer

@export var edge: PackedScene
@export var data: Dictionary = {}
@export var outArr := []
@export var inArr := []
@export var nodeSet := {}
@export var edgeArr := []
@export var doc := {}
@onready var title := $VBoxContainer/HBoxContainer/Title
@onready var subtitle := $VBoxContainer/Subtitle
@onready var click := $Click

func _enter_tree() -> void:
	doc.merge(data.get("document", {}))
	data.set("children", [])
	data.set("parents", [])
	if(data.has("pos")):
		position = Vector2(data["pos"][0], data["pos"][1])

func _ready() -> void:
	title.text = data.get("name", "Unnamed Node")
	var subtitleData = data.get("subtitle", "")
	if(subtitleData is Array): subtitleData = "\n".join(subtitleData)
	subtitle.text = subtitleData

func parentOf(connection: Array):
	var parent = connection[0]
	var child = connection[1]
	var currEdge = edge.instantiate()
	outArr.append(currEdge)
	currEdge.parentName = parent
	currEdge.childName = child
	currEdge.origin = parent
	currEdge.outgoing = true
	currEdge.nodeSet = nodeSet
	data["parents"].append(parent)
	data["children"].append(child)
	edgeArr.append(currEdge)
	add_child(currEdge)

func childOf(connection: Array):
	var parent = connection[0]
	var child = connection[1]
	var currEdge = edge.instantiate()
	currEdge.parentName = parent
	currEdge.childName = child
	currEdge.origin = child
	currEdge.outgoing = false
	currEdge.nodeSet = nodeSet
	edgeArr.append(currEdge)
	add_child(currEdge)

@export var lastPos := Vector2(0,0)
@export var draggable := false
@export var zoomPointer := []
func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("tree_node_display")):
		click.play()
		return
	if(event.is_action_pressed("tree_node_click")): draggable = true
	if(event.is_action_released("tree_node_click")): draggable = false
	if(event is InputEventMouseMotion): 
		if(draggable): position += (event.global_position - lastPos) / zoomPointer[0]
		lastPos = event.global_position
