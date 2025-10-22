extends Node

@onready var statistics_container: VBoxContainer = $/root/Game/CanvasLayer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer

var max_population: int = 8_253_443_180
var current_population: int
var current_cultist: int

func _ready() -> void:

	# handles new cultist created
	EventBus.cultist_created.connect(_on_new_conversion)

	# ui setup
	current_population = max_population
	current_cultist = 0
	var max_population_label: Label = statistics_container.get_node("HBoxPopulation/MaxPopulationLabel")
	max_population_label.text ="%s" %  max_population
	var max_cultist_label: Label = statistics_container.get_node("HBoxCultist/MaxCultistLabel")
	max_cultist_label.text = "%s" % max_population
	_on_new_conversion(0)

func _on_new_conversion(new_cultist):
	# update ui
	current_population -= new_cultist
	current_cultist += new_cultist
	var current_population_label: Label = statistics_container.get_node("HBoxPopulation/CurrentPopulationLabel")
	current_population_label.text ="%s" %  current_population
	var current_cultist_label: Label = statistics_container.get_node("HBoxCultist/CurrentCultistLabel")
	current_cultist_label.text = "%s" % current_cultist
	
	if current_cultist == 1:
		FeaturesGraph.unlock_node(FeaturesGraph.altar)
