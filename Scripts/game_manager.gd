extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F12:
			FeaturesGraph.unlock_next_node()
