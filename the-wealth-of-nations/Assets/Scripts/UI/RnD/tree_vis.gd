extends Control

@export var pos := Vector2(0,0)
@export var zoom := 1.0
@export var ptr := [zoom]
@export var draggable := false
@export var lastPos := Vector2(0,0)
@onready var nodeSpace := $ColorRect/SubViewportContainer/SubViewport/NodeSpace
@onready var viewport := $ColorRect/SubViewportContainer
@onready var viewportScreen := $ColorRect/SubViewportContainer/SubViewport

@onready var node = preload("res://Assets/Scenes/TechTree/Node.tscn")
@onready var edge = preload("res://Assets/Scenes/TechTree/NodePointer.tscn")
@onready var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://Misc/treedata.json"))
@onready var nodeSet := {}
@onready var edgeArr := []

func _ready() -> void:
	for n in data["Nodes"]:
		addNode(n, data["Nodes"][n])
	for c in data["Connections"]:
		addConnection(c)

func addNode(n: String, dict: Dictionary):
	var currNode := node.instantiate()
	nodeSet.set(n, currNode)
	currNode.data = dict
	currNode.edge = edge
	currNode.nodeSet = nodeSet
	currNode.edgeArr = edgeArr
	currNode.zoomPointer = ptr
	nodeSpace.add_child(currNode)

func addConnection(c: Array):
	nodeSet[c[0]].parentOf(c)
	nodeSet[c[1]].childOf(c)

func _on_sub_viewport_container_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("tree_draggable")): draggable = true
	if(event.is_action_released("tree_draggable")): 
		draggable = false
	if(event.is_action_pressed("tree_scroll_in")): changeZoom(zoom * 1.1)
	if(event.is_action_pressed("tree_scroll_out")): changeZoom(zoom / 1.1)
	if(event is InputEventMouseMotion): 
		if(draggable): pos += event.position - lastPos
		lastPos = event.position
	#print(lastPos - pos)
	refreshViewport()

func changeZoom(newZoom: float):
	var oldZoom := zoom
	zoom = clamp(newZoom, 0.1, 5)
	ptr[0] = zoom
	var zoomRatio := zoom / oldZoom
	var viewPos = lastPos - pos
	var diff = viewPos * zoomRatio - viewPos
	pos -= diff

func refreshViewport():
	nodeSpace.position = pos
	nodeSpace.scale = Vector2(zoom,zoom)
