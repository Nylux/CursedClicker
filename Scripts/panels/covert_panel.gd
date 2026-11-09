class_name CovertPanel extends Node

var ui: TemplateUI
var ui_placeholder: Control

func _init(
	p_ui: TemplateUI,
	p_ui_placeholder: Control,
	p_title: String,
) -> void:
	ui = p_ui
	ui_placeholder = p_ui_placeholder
	ui.title_node.text = p_title


func _ready() -> void:
	FeaturesNode.covert.connect_unlocked(FeaturesUtils.activate.bind(ui, ui_placeholder))


func resolve_ui() -> void:
	pass
