class_name GameUI extends RefCounted

var resources_container: GridContainer
var blood_label: Label
var corruption_label: Label
var population_label: Label
var cultist_label: Label
var zealot_label: Label
var infiltrator_label: Label

var faith_label: Label
var discipline_label: Label
var moral_label: Label
var knowledge_label: Label

var button_container: HBoxContainer
var button_group: ButtonGroup

var ritual_panel: RitualPanel
var infiltration_panel: InfiltrationPanel

func _init(
	p_parent: Node,
	p_game_state: GameState,
	p_ritual_panel: RitualPanel,
	p_infiltration_panel: InfiltrationPanel
) -> void:

	resources_container = Utils.get_component(p_parent, "ResourcesContainer")

	blood_label = Utils.get_component(resources_container, "BloodLabel")
	corruption_label = Utils.get_component(resources_container, "CorruptionLabel")
	population_label = Utils.get_component(resources_container, "PopulationLabel")
	cultist_label = Utils.get_component(resources_container, "CultistLabel")
	zealot_label = Utils.get_component(resources_container, "ZealotLabel")
	infiltrator_label = Utils.get_component(resources_container, "InfiltratorLabel")

	faith_label = Utils.get_component(resources_container, "FaithLabel")
	discipline_label = Utils.get_component(resources_container, "DisciplineLabel")
	moral_label = Utils.get_component(resources_container, "MoralLabel")
	knowledge_label = Utils.get_component(resources_container, "KnowledgeLabel")

	button_group = load("res://button_group_click_modifier.tres")
	button_container = Utils.get_component(p_parent, "ClickContainer")
	Utils.get_component(button_container, "ButtonTimes1").text = "X   1"
	Utils.get_component(button_container, "ButtonTimes10").text = "X   10"
	Utils.get_component(button_container, "ButtonTimes100").text = "X  100"
	Utils.get_component(button_container, "ButtonTimes1000").text = "X 1000"

	ritual_panel = p_ritual_panel
	infiltration_panel = p_infiltration_panel
	infiltration_panel.create_labels(p_game_state.countries)