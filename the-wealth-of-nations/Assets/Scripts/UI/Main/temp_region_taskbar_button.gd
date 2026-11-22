extends Button

func _pressed() -> void:
	Main.open_region(randi_range(0, Enums.Region.size() - 1))
