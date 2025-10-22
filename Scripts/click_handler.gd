extends Node

var button_container: HBoxContainer
@export var button_group: ButtonGroup

func _ready() -> void:
	button_container = $/root/Game/CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer
	EventBus.clicked.connect(_on_ui_clicked)
	button_group.pressed.connect(_on_button_group_pressed)

	## button group
	var button1: Button = button_container.get_node("ButtonTimes1")
	button1.text = "X   1"
	var button10: Button = button_container.get_node("ButtonTimes10")
	button10.text = "X   10"
	var button100: Button = button_container.get_node("ButtonTimes100")
	button100.text = "X  100"
	var button1000: Button = button_container.get_node("ButtonTimes1000")
	button1000.text = "X 1000"

func _on_ui_clicked(_ui: AnimatedTextureRect) -> void:
	GameManager.count_click += 1

func _on_button_group_pressed(button: Button) -> void:
	match button.name:
		"ButtonTimes1":
			GameManager.click_multiplier = 1
		"ButtonTimes10":
			GameManager.click_multiplier = 10
		"ButtonTimes100":
			GameManager.click_multiplier = 100
		"ButtonTimes1000":
			GameManager.click_multiplier = 1000
