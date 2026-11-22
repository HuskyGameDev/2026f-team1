extends HBoxContainer
class_name RecipeResourceIndicator

@export var icon_display : TextureRect
@export var count_display : Label

var resource : Enums.GameResource :
	get:
		return resource
	set(val):
		resource = val
		icon_display.texture = Enums.resource_get_icon(resource)
var count : int : 
	get:
		return int(count_display.text)
	set(val):
		count_display.text = str(val)
