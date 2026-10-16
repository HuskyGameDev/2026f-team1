extends Control

@onready var vis = $Divider/Visualizer 
@onready var menu = $Divider/Menudisp
@onready var menuElems := {
	"header": $Divider/Menudisp/Background/VBox/Header,
	"image": $Divider/Menudisp/Background/VBox/Image,
	"text": $Divider/Menudisp/Background/VBox/Text
}
@onready var nodemenuimg := preload("res://customTree/nodemenuimg.tres")
@onready var node = preload("res://customTree/Node.tscn")
@onready var line = preload("res://customTree/Connection.tscn")
@onready var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://treedata.json"))
@onready var nodeSet := {}

func _ready() -> void:
	for n in data["Nodes"]:
		var currNode := node.instantiate()
		nodeSet.set(n, currNode)
		currNode.data = data["Nodes"][n]
		currNode.line = line
		currNode.nodeSet = nodeSet
		currNode.position_offset_changed.connect(lineAlign)
		currNode.node_selected.connect(displayMenu.bind(currNode.doc))
		currNode.node_deselected.connect(hideMenu)
		print(currNode.size)
	for c in data["Connections"]:
		nodeSet[c[0]].parentOf(c)
		
	lineAlign()

func lineAlign():
	for n in nodeSet:
		for l in nodeSet[n].lineArr:
			var pNode = nodeSet[l.parentName]
			var qNode = nodeSet[l.childName]
			var ppos: Vector2 = pNode.position_offset
			var children := Array(pNode.data.get("children", []))
			var pfrac = (children.find(l.childName) + 0.5) / float(children.size())
			var pend = pNode.size[0] * (0.5 if(pfrac < 0 || pfrac > 1) else pfrac)
			var qpos: Vector2 = qNode.position_offset
			var parents := Array(qNode.data.get("parents", []))
			var qfrac = (parents.find(l.parentName) + 0.5) / float(parents.size())
			var qend = qNode.size[0] * (0.5 if(qfrac < 0 || qfrac > 1) else qfrac)
			
			l.set_point_position(0, Vector2(pend, 0))
			l.set_point_position(3, Vector2(qpos.x - ppos.x + qend, qpos.y - ppos.y + qNode.size[1]))
			var p0 = l.get_point_position(0)
			var p3 = l.get_point_position(3)
			l.set_point_position(1, Vector2(p0.x, (p3.y + p0.y) * 0.25))
			l.set_point_position(2, Vector2(p3.x, (p3.y + p0.y) * 0.75))
			#print(ppos, " -> ", qpos)
			#print(pend, " -> ", qend)

func displayMenu(docdata := {}):
	menu.visible = true
	vis.scroll_offset.x += 240
	print(docdata)
	print(nodeSet.values().map(func(element): return element.size))
	if (!docdata.is_empty()):
		editDocument(docdata, "header", "text", "Unnamed Node")
		var img = Texture2D.new()
		img.resource_path = "res://icon.svg"
		editDocument(docdata, "image", "texture", nodemenuimg)
		editDocument(docdata, "text", "text", "[Empty]")

func hideMenu():
	menu.visible = false
	vis.scroll_offset.x -= 240

func editDocument(docdata: Dictionary, section: String, prop: String, default = ""):
	menuElems[section].call("set", prop, docdata.get(section, default))
