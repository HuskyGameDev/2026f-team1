extends PanelContainer
class_name BuildingDisplay

@export var recipe_resource_indicator_scene : PackedScene

@export var label : Label
@export var quantity_label : Label
@export var progress_bar : ProgressBar
@export var inputs_container : HBoxContainer
@export var outputs_container : HBoxContainer
@export var build_button : Button

var bound_region : Enums.Region
@warning_ignore("int_as_enum_without_match")
var bound_building : Enums.Building = -1 as Enums.Building: # Starts as an impossible value to show that it's unset
	get:
		return bound_building
	set(val):
		if (bound_building != val):
			bound_building = val
			label.text = Enums.building_get_name(bound_building)
			update_quantity()
			build_button.text = "Build (" + str(Enums.building_get_cost(bound_building)) + "$)"
			_bind_recipe(Enums.building_get_recipe(bound_building))

func _ready() -> void:
	build_button.pressed.connect(_build_pressed)

func _process(_delta: float) -> void:
	if (is_visible_in_tree()):
		progress_bar.value = Globals.get_building_progress(bound_region, bound_building)

func update_quantity() -> void:
	quantity_label.text = "x" + str(Globals.regional_building_counts[bound_region][bound_building])

func _bind_recipe(rec: Recipe) -> void: ## For purposes of setting up the recipe display
	for i in max(rec.input_count, inputs_container.get_child_count()):
		var child : RecipeResourceIndicator
		if (i >= inputs_container.get_child_count()):
			child = recipe_resource_indicator_scene.instantiate()
			inputs_container.add_child(child)
		elif (i >= rec.input_count):
			inputs_container.get_child(i).queue_free()
			continue
		else:
			child = inputs_container.get_child(i)
		
		child.resource = rec.input_resources[i]
		child.count = rec.input_quantities[i]
	
	for i in max(rec.output_count, outputs_container.get_child_count()):
		var child : RecipeResourceIndicator
		if (i >= outputs_container.get_child_count()):
			child = recipe_resource_indicator_scene.instantiate()
			outputs_container.add_child(child)
		elif (i >= rec.input_count):
			outputs_container.get_child(i).queue_free()
			continue
		else:
			child = outputs_container.get_child(i)
		
		child.resource = rec.output_resources[i]
		child.count = rec.output_quantities[i]

func _build_pressed() -> void:
	if (Globals.money < Enums.building_get_cost(bound_building)):
		return
	
	Globals.money -= Enums.building_get_cost(bound_building)
	Globals.regional_building_counts[bound_region][bound_building] += 1
	update_quantity()
