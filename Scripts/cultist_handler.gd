extends Node

@onready var statistics_container: GridContainer = $/root/Game/CanvasLayer/VBoxContainer/HBoxContainer/MarginContainer/ResourceContainer

var max_population: int = 8_253_443_180
var current_population: int
var current_cultist: int
var current_zealot: int
var current_infiltrator: int

func _ready() -> void:
	# handles new cultist created
	EventBus.cultist_created.connect(_on_cultist_created)
	EventBus.sacrifice_created.connect(_on_cultist_sacrificied)

	# ui setup
	current_population = max_population
	current_cultist = 0
	current_zealot = 0
	current_infiltrator = 0
	update_ui()

func _on_cultist_created(amount: int):
	current_population -= amount
	current_cultist += amount
	EventBus.cultist_changed.emit(current_cultist)
	update_ui()

func _on_cultist_sacrificied(amount: int):
	var sacrificied_amout: int = min(amount, current_cultist)
	current_cultist -= sacrificied_amout
	EventBus.blood_created.emit(sacrificied_amout)
	update_ui()

func update_ui() -> void:
	var population_label: Label = statistics_container.get_node("HBoxPopulation/PopulationLabel")
	population_label.text ="%s" %  current_population
	var cultist_label: Label = statistics_container.get_node("HBoxCultist/CultistLabel")
	cultist_label.text = "%s" % current_cultist
	var zealot_label: Label = statistics_container.get_node("HBoxZealot/ZealotLabel")
	zealot_label.text = "%s" % current_zealot
	var infiltrator_label: Label = statistics_container.get_node("HBoxInfiltrator/InfiltratorLabel")
	infiltrator_label.text = "%s" % current_infiltrator
