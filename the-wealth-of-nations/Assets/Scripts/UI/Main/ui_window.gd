extends PanelContainer
class_name UIWindow

const scene_path : String = "res://Assets/Scenes/ui_window.tscn"
const resize_padding : float = 12.0 ## The maximum distance from the edge of the window you can click at if you want to resize

@export var label_display : Label
@export var close_button : Button
@export var children_viewport : PanelContainer

# -1 if left/up, 0 if none, 1 if right/down
var resize_x_mode : int = 0
var resize_y_mode : int = 0
var dragging : bool = false
var drag_offset : Vector2 = Vector2.ZERO

var label : String :
	get:
		return label_display.text
	set(val):
		label_display.text = val

var is_open : bool :
	get:
		return visible
	set(val):
		if (val != visible):
			if (val):
				open()
			else:
				close()

@warning_ignore("shadowed_variable")
static func wrap_in_window(label : String, ctrl : Control) -> UIWindow: ## Creates a UI window, adds the passed control as a child, and returns the window
	var new : UIWindow = preload(scene_path).instantiate()
	if (ctrl.get_parent() != null):
		ctrl.get_parent().remove_child(ctrl)
	new.add_to_children(ctrl)
	new.label = label
	return new

func _ready() -> void:
	close_button.pressed.connect(close)

func _process(_delta: float) -> void:
	var local_mouse_pos = get_local_mouse_position()
	
	# RESIZING/DRAGGING LOGIC #
	if (resize_x_mode == -1): # Resize left
		var last_sz := size.x
		size.x -= local_mouse_pos.x
		position.x += last_sz - size.x
	elif (resize_x_mode == 1): # Resize right
		size.x = local_mouse_pos.x
	
	if (resize_y_mode == -1): # Resize up
		var last_sz := size.y
		size.y -= local_mouse_pos.y
		position.y += last_sz - size.y
	elif (resize_y_mode == 1): # Resize down
		size.y = local_mouse_pos.y
	
	if (dragging):
		position += local_mouse_pos - drag_offset
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var e := event as InputEventMouseButton
		
		if (e.button_index == MouseButton.MOUSE_BUTTON_LEFT):
			if (e.is_pressed()):
				if (e.position.x <= resize_padding): # Resize left
					resize_x_mode = -1
				elif (e.position.x >= size.x - resize_padding): # Resize right
					resize_x_mode = 1
				
				if (e.position.y <= resize_padding): # Resize up
					resize_y_mode = -1
				elif (e.position.y >= size.y - resize_padding): # Resize down
					resize_y_mode = 1
				
				if (resize_x_mode == 0 && resize_y_mode == 0): # Drag
					dragging = true
					drag_offset = e.position
			
			elif (e.is_released()):
				resize_x_mode = 0
				resize_y_mode = 0
				dragging = false

func open() -> void:
	visible = true

func close() -> void:
	visible = false

func add_to_children(ctrl : Control) -> void: ## Use this instead of add_child for proper window behavior
	children_viewport.add_child(ctrl)

func remove_from_children(ctrl : Control) -> void: ## Use this instead of remove_child for proper window behavior
	children_viewport.remove_child(ctrl)

func get_from_children(idx : int) -> Control: ## Use this instead of get_child for proper window behavior
	return children_viewport.get_child(idx)
