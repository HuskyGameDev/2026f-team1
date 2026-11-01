extends Control
class_name HRMenu

@export var tree_node_scene : PackedScene
@export var employee_display_scene : PackedScene
@export var employee_tree : VBoxContainer

var category_nodes : Array[TreeNode]
var job_nodes : Array[TreeNode]

func _ready() -> void:
	# INITIALIZE EMPLOYEE TREE #
	category_nodes.resize(Enums.job_category_count)
	job_nodes.resize(Enums.Job.size()) # This could technically be more compact but for simplicity's sake I'll just let the indexes be the job ID
	
	var last_category_id : int = -1
	var category_node : TreeNode
	@warning_ignore("int_as_enum_without_cast")
	for job : Enums.Job in Enums.Job.size():
		if (Enums.job_get_category_id(job) != last_category_id):
			last_category_id = Enums.job_get_category_id(job)
			
			category_node = tree_node_scene.instantiate()
			category_node.label = Enums.job_get_category_name_from_category_id(last_category_id)
			employee_tree.add_child(category_node)
			category_nodes[last_category_id] = category_node
			
			continue
		
		var node : TreeNode = tree_node_scene.instantiate()
		node.label = Enums.job_get_name(job)
		category_node.add_to_children(node)
		job_nodes[job as int] = node
	
	for emp : Employee in Globals.employees:
		add_employee_to_tree(emp)
	Globals.employee_added.connect(add_employee_to_tree)
	Globals.employee_removed.connect(remove_employee_from_tree)

func add_employee_to_tree(emp : Employee):
	var new : EmployeeDisplay = employee_display_scene.instantiate()
	new.bind_employee(emp)
	job_nodes[emp.job as int].add_to_children(new)

func remove_employee_from_tree(emp : Employee):
	var targ : EmployeeDisplay = emp.bound_display
	job_nodes[emp.job as int].remove_from_children(targ)
	targ.queue_free()
