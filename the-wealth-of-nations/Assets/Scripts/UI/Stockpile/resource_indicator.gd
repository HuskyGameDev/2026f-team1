extends HBoxContainer
class_name ResourceIndicator

const value_smoothing_const : float = 0.03
const value_snap_diff : float = 0.1

@export var icon_display : TextureRect
@export var count_display : Label

var displayed_value : float = 0.0

var bound_resource : Enums.GameResource :
	get:
		return bound_resource
	set(val):
		bound_resource = val
		icon_display.texture = Enums.resource_get_icon(bound_resource)

func _process(_delta: float) -> void:
	# Value smoothing
	var targ : float = Globals.resource_counts[bound_resource]
	if (displayed_value != targ):
		displayed_value += (targ - displayed_value) * value_smoothing_const
		if (abs(displayed_value - targ) <= value_snap_diff):
			displayed_value = targ
		count_display.text = str(round(displayed_value) as int)
