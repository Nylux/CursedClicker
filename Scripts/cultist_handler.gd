extends Node

@onready var statistics_container: VBoxContainer = $/root/Game/CanvasLayer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer

var max_population: int = 8_253_443_180
var current_population: int
var current_cultist: int

func _ready() -> void:
	# handles new cultist created
	EventBus.cultist_created.connect(_on_cultist_created)
	EventBus.cultist_sacrificied.connect(_on_cultist_sacrificied)

	# ui setup
	current_population = max_population
	current_cultist = 0
	update_ui()

func _on_cultist_created(amount: int):
	current_population -= amount
	current_cultist += amount
	EventBus.cultist_changed.emit(current_cultist)
	update_ui()

func _on_cultist_sacrificied(amount: int):
	var sacrificied_amout: int = min(amount, current_cultist)
	current_cultist -= sacrificied_amout
	max_population -= sacrificied_amout
	EventBus.blood_created.emit(sacrificied_amout)
	update_ui()

func update_ui() -> void:
	var current_population_label: Label = statistics_container.get_node("HBoxPopulation/CurrentPopulationLabel")
	current_population_label.text ="%s" %  current_population
	var current_cultist_label: Label = statistics_container.get_node("HBoxCultist/CurrentCultistLabel")
	current_cultist_label.text = "%s" % current_cultist
	var max_population_label: Label = statistics_container.get_node("HBoxPopulation/MaxPopulationLabel")
	max_population_label.text ="%s" %  max_population
	var max_cultist_label: Label = statistics_container.get_node("HBoxCultist/MaxCultistLabel")
	max_cultist_label.text = "%s" % max_population
	
