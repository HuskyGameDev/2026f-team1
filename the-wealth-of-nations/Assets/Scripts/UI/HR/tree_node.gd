extends VBoxContainer
class_name TreeNode

var label : String : 
	get:
		return label_display.text
	set(val):
		label_display.text = val
var showing_children : bool : 
	get:
		return children_padding.visible
	set(val):
		children_padding.visible = val

@export var display : Control
@export var expand_button : Button
@export var label_display : Label
@export var children_padding : PanelContainer
@export var children_container : VBoxContainer

func _ready() -> void:
	showing_children = false
	expand_button.pressed.connect(_expand_pressed)

func add_to_children(ctrl : Control) -> void: ## Use this instead of add_child for proper tree behavior
	children_container.add_child(ctrl)

func remove_from_children(ctrl : Control) -> void: ## Use this instead of add_child for proper tree behavior
	children_container.remove_child(ctrl)

func get_from_children(idx : int) -> Control: ## Use this instead of get_child for proper tree behavior
	return children_container.get_child(idx)

func move_in_children(ctrl : Control, idx : int) -> void: ## Use this instead of move_child for proper tree behavior
	children_container.move_child(ctrl, idx)

func _expand_pressed() -> void:
	showing_children = !showing_children
