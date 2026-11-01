extends Node
signal change_color

var RandomColors: Array = [Color(255,0,0), Color(0,255,0), Color(0,0,255), Color(0.27,0,0.18), Color(0.21, 0.357, 0.413, 1.0)]
var LastColor: Color

func runEvent(input: Array):
	if input.size() > 0:
		print("Colorizing with input!")
		change_color.emit(input[0])
		return
	
	var NewColor = RandomColors[randi() % RandomColors.size()]
	while NewColor == LastColor:
		NewColor = RandomColors[randi() % RandomColors.size()]
	LastColor = NewColor
	change_color.emit(NewColor)
