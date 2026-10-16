extends Control
@onready var source := $GraphEdit/GraphNode
@onready var receiver := $GraphEdit/GraphNode2
@onready var connection := $GraphEdit/GraphNode/Line2D
@onready var t1 := $FoldableContainer/Control/TextureRect
@onready var t2 := $FoldableContainer/Control2/TextureRect2
@onready var rSignal := receiver.get_signal_list()

func _ready() -> void:
	print(rSignal)

func _on_graph_node_2_position_offset_changed() -> void:
	pass # Replace with function body.
#func _on_graph_node_2_dragged(from: Vector2, to: Vector2) -> void:
	var ppos = source.position_offset
	var qpos = receiver.position_offset
	var pdim = source.size
	var qdim = receiver.size
	var carr = [0.5,0.0,0.5,1.0]
	#print(ppos, " -> ", to, " of ", pdim, " and ", qdim)
	#print(to.x - ppos.x, " , ", to.y - ppos.y)
	#print(connection.points)
	
	connection.set_point_position(0, Vector2(carr[0]*pdim[0], carr[1]*pdim[1]))
	connection.set_point_position(3, 
		Vector2(qpos.x - ppos.x + carr[2]*qdim[0], qpos.y - ppos.y + carr[3]*qdim[1]))
	var p0 = connection.get_point_position(0)
	var p3 = connection.get_point_position(3)
	connection.set_point_position(1, Vector2(p0.x, (p3.y + p0.y) * 0.25))
	connection.set_point_position(2, Vector2(p3.x, (p3.y + p0.y) * 0.75))
	pass # Replace with function body.


func _on_graph_node_2_node_selected() -> void:
	t1.visible = false
	t2.visible = true
	pass # Replace with function body.


func _on_graph_node_node_selected() -> void:
	t1.visible = true
	t2.visible = false
	pass # Replace with function body.
