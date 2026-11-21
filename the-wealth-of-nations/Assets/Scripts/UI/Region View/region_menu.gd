extends PanelContainer
class_name RegionMenu

var window : UIWindow ## Assigned by Main after wrapping

@export var building_display_scene : PackedScene
@export var building_list : VBoxContainer

func open_region(reg : Enums.Region) -> void:
	var building_counts : Array = Globals.regional_building_counts[reg] # Can't cast to an array of ints apparently
	
	var chidx : int = 0
	for b in building_counts.size():
		if (building_counts[b] == 0):
			continue
		var disp : BuildingDisplay
		if (chidx >= building_list.get_child_count()):
			disp = building_display_scene.instantiate()
			building_list.add_child(disp)
		else:
			disp = building_list.get_child(chidx)
		
		disp.bound_region = reg
		disp.bound_building = b as Enums.Building
		chidx += 1
	
	if (chidx < building_list.get_child_count()):
		for i in range(chidx, building_list.get_child_count()):
			building_list.get_child(i).queue_free()
	
	if (window != null):
		window.label = "Regional Report: " + Enums.region_get_name(reg)
		window.is_open = true
