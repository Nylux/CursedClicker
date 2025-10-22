extends Node2D

var click_multiplier: int = 1

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F12:
			FeaturesGraph.unlock_next_node()
