extends Control

# refs
@onready var start_button = $"VBoxContainer/MenuButtons/StartGameBtn"
@onready var quit_button = $"VBoxContainer/MenuButtons/QuitBtn"

func _ready():
	start_button.connect("pressed", _on_StartGameBtn_pressed)
	quit_button.connect("pressed", _on_QuitBtn_pressed)

func _on_StartGameBtn_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()
