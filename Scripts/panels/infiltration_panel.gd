class_name InfiltrationPanel extends Node

var ui: TemplateUI
var ui_placeholder: Control

var spy_button: Button
var infiltrate_button: Button
var unrest_button: Button

var spy_label: Label
var infiltrate_label: Label
var unrest_label: Label

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


func resolve_ui() -> void:
	pass

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