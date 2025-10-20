extends Control

# refs
@onready var game_over_label = $"VBoxContainer/GameOverMargin/GameOverLabel"
@onready var back_to_menu_button = $"VBoxContainer/Buttons/BackToMenuBtn"
@onready var quit_button = $"VBoxContainer/Buttons/QuitBtn"

func _ready():
	#game_over_label.text = globals.game_over_state
	back_to_menu_button.connect("pressed", _on_BackToMenuBtn_pressed)
	quit_button.connect("pressed", _on_QuitBtn_pressed)

func _on_BackToMenuBtn_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()
