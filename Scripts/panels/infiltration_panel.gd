class_name InfiltrationPanel extends Node

var ui: TemplateUI
var ui_placeholder: Control

var spy_button: Button
var infiltrate_button: Button
var unrest_button: Button

var spy_label: Label
var infiltrate_label: Label
var unrest_label: Label

var countries_label: Dictionary[int, Label]

func _init(
	p_ui: TemplateUI,
	p_ui_placeholder: Control,
	p_title: String,
) -> void:
	ui = p_ui
	ui_placeholder = p_ui_placeholder
	ui.title_node.text = p_title


func _ready() -> void:
	FeaturesNode.infiltration.connect_unlocked(FeaturesUtils.activate.bind(ui, ui_placeholder))
	
	create_button(spy_button, spy_label, "Spy")
	create_button(infiltrate_button, infiltrate_label, "Infiltrate")
	create_button(unrest_button, unrest_label, "Unrest")


func resolve_ui(countries: Dictionary[int, CountryData]) -> void:
	for country_id in countries:
		countries_label[country_id].text = "%s: %s" % [
			countries[country_id].name,
			countries[country_id].treasury,
		]


func create_button(button: Button, label: Label, button_text: String) -> void:
	var container = HBoxContainer.new()
	button = Button.new()
	button.text = button_text
	container.add_child(button)
	label = Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(label)
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui.upgrade_container.add_child(container)


func create_labels(countries: Dictionary[int, CountryData]) -> void:
	for country_id in countries:
		var label = Label.new()
		label.text = "%s: LOREM IPSUM" % countries[country_id].name
		ui.stat.add_child(label)
		countries_label[country_id] = label