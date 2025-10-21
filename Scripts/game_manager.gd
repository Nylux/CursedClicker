extends Node2D

@onready var button_container: HBoxContainer = $CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer
@onready var statistics_container: VBoxContainer = $CanvasLayer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer
@export var button_group: ButtonGroup

var click_multiplier: int = 1
var max_population: int = 8_253_443_180
var current_population: int
var current_cultist: int

func _ready() -> void:
	var button1: Button = button_container.get_node("ButtonTimes1")
	button1.text = "X   1"
	var button10: Button = button_container.get_node("ButtonTimes10")
	button10.text = "X   10"
	var button100: Button = button_container.get_node("ButtonTimes100")
	button100.text = "X  100"
	var button1000: Button = button_container.get_node("ButtonTimes1000")
	button1000.text = "X 1000"
	
	current_population = max_population
	current_cultist = 0
	var current_population_label: Label = statistics_container.get_node("HBoxPopulation/CurrentPopulationLabel")
	current_population_label.text ="%s" %  current_population
	var max_population_label: Label = statistics_container.get_node("HBoxPopulation/MaxPopulationLabel")
	max_population_label.text ="%s" %  max_population
	var current_cultist_label: Label = statistics_container.get_node("HBoxCultist/CurrentCultistLabel")
	current_cultist_label.text = "%s" % current_cultist
	var max_cultist_label: Label = statistics_container.get_node("HBoxCultist/MaxCultistLabel")
	max_cultist_label.text = "%s" % max_population
	
	button_group.pressed.connect(_on_button_group_pressed)

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Effect %s" % click_multiplier)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			print("Effect %s" % (-1 * click_multiplier))
