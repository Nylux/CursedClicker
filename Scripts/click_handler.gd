extends Node

@onready var button_container: HBoxContainer = $/root/Game/CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer
@export var button_group: ButtonGroup

var click_multiplier: int = 1
var count_click: int = 0

func _ready() -> void:
	EventBus.clicked.connect(_on_ui_clicked)
	EventBus.asked_cultist_sacrificied.connect(_on_asked_cultist_sacrificied)
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
	count_click += 1

func _on_button_group_pressed(button: Button) -> void:
	match button.name:
		"ButtonTimes1":
			click_multiplier = 1
		"ButtonTimes10":
			click_multiplier = 10
		"ButtonTimes100":
			click_multiplier = 100
		"ButtonTimes1000":
			click_multiplier = 1000

func _on_asked_cultist_sacrificied() -> void:
	EventBus.cultist_sacrificied.emit(click_multiplier)
