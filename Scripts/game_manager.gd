extends Node2D

@onready var button_container: HBoxContainer = $CanvasLayer/VBoxContainer/HBoxContainer/HBoxContainer
@onready var statistics_container: VBoxContainer = $CanvasLayer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer
@export var button_group: ButtonGroup

var click_multiplier: int = 1
var max_population: int = 8_253_443_180
var current_population: int
var current_cultist: int

func _ready() -> void:
	## button group
	var button1: Button = button_container.get_node("ButtonTimes1")
	button1.text = "X   1"
	var button10: Button = button_container.get_node("ButtonTimes10")
	button10.text = "X   10"
	var button100: Button = button_container.get_node("ButtonTimes100")
	button100.text = "X  100"
	var button1000: Button = button_container.get_node("ButtonTimes1000")
	button1000.text = "X 1000"
	button_group.pressed.connect(_on_button_group_pressed)
	
	## ui text
	current_population = max_population
	current_cultist = 0
	var max_population_label: Label = statistics_container.get_node("HBoxPopulation/MaxPopulationLabel")
	max_population_label.text ="%s" %  max_population
	var max_cultist_label: Label = statistics_container.get_node("HBoxCultist/MaxCultistLabel")
	max_cultist_label.text = "%s" % max_population
	_on_new_conversion(0)

	FeaturesGraph.rituals.connect_unlocked(features_creation.bind(0))
	FeaturesGraph.rituals_stat.connect_unlocked(features_creation.bind(1))
	FeaturesGraph.rituals_stat_power.connect_unlocked(features_creation.bind(2))
	FeaturesGraph.rituals_improve_click1.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click2.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click3.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click4.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click5.connect_unlocked(features_creation.bind(3))

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
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F12:
			FeaturesGraph.unlock_next_node()

func _on_new_conversion(new_cultist):
	current_population -= new_cultist
	current_cultist += new_cultist
	var current_population_label: Label = statistics_container.get_node("HBoxPopulation/CurrentPopulationLabel")
	current_population_label.text ="%s" %  current_population
	var current_cultist_label: Label = statistics_container.get_node("HBoxCultist/CurrentCultistLabel")
	current_cultist_label.text = "%s" % current_cultist

func features_creation(index: int) -> void:
	match index:
		0:
			$CanvasLayer/VBoxContainer/GridContainer/Control.visible = false
			$CanvasLayer/VBoxContainer/GridContainer/TemplateUi.visible = true
			$RitualsHandler.on_ready()
			$RitualsHandler.cultist_created.connect(_on_new_conversion.bind(1))
		1:
			$RitualsHandler.create_stats()
		2:
			$RitualsHandler.unlock_stat(0)
		3:
			$RitualsHandler.click_power_add(0.25)
		_:
			push_error("Invalid feature %s" % index)
