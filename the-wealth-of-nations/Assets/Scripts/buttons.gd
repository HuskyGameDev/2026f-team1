extends Button

@export var sfx_eagle: AudioStreamPlayer2D
@onready var color_rect: ColorRect = $"../Fade/ColorRect"

func _ready() -> void:
	color_rect.color.a = 0.0
	color_rect.visible = false

func fade(target_alpha: float, duration: float = 1.0):
	color_rect.visible = true
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", target_alpha, duration)
	return tween

func _pressed() -> void:
	if name == "NewGame":
		sfx_eagle.play()
		await fade(1.0, 1.5).finished
		get_tree().change_scene_to_file("res://Assets/Scenes/game.tscn")
	else:
		get_tree().quit()
