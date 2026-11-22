extends Control

@export var nodeSet := {}
@export var parentName := ""
@export var childName := ""
@export var origin := ""
@export var outgoing := true

@onready var confirm := $ConfirmSound
@onready var deny := $DenySound

func _process(_delta: float) -> void:
	setPosition()

func setPosition():
	var p1 := nodeCenter(parentName)
	var p2 := nodeCenter(childName)
	var nSiz = nodeSet[origin].size + Vector2(24,24)
	var box: PackedVector2Array = [
		Vector2(-24,-24),
		Vector2(-24,nSiz.y),
		Vector2(nSiz.x,nSiz.y),
		Vector2(nSiz.x,-24)
	]
	var line: PackedVector2Array = [
		p1,
		p2
	]
	rotation = (p2 - p1).angle()
	if(p1 == p2): return
	position = Geometry2D.intersect_polyline_with_polygon(line, box)[0][1 if(outgoing)else 0]

func nodeCenter(n: String) -> Vector2:
	var nPos = relativePosOf(n)
	var nSiz = nodeSet[n].size
	return Vector2(nPos.x + (nSiz.x / 2), nPos.y + (nSiz.y / 2))

func relativePosOf(n: String) -> Vector2:
	return nodeSet[n].position - nodeSet[origin].position


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_action_pressed("tree_node_click")):
		if(outgoing): confirm.play()
		else: deny.play()
