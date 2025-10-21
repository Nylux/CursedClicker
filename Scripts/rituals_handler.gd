extends Node

class_name RitualsHandler

signal cultist_created
signal click_power_changed(value)

@export var ui: SubViewportContainer
@export var title: String
var animated_texture: AnimatedTextureRect

var click_power: float = 0.5
var current_power: float = 0.0
var n_stat: int = 1

func on_ready() -> void:
	ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/VBoxContainer/Title").text = title
	animated_texture = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect")
	EventBus.clicked.connect(_on_ui_clicked)
	animated_texture.complete_circle.connect(_on_complete_circle)
	
	current_power = 0.0

func create_stats():
	var stat_container = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/MarginContainer")
	stat_container.visible = true
	var stat = stat_container.get_node("Statistics")
	
	var stat_title = Label.new()
	stat_title.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stat_title.text = "Statistics"
	stat.add_child(stat_title)

	for i in n_stat:
		var placeholder = Control.new()
		placeholder.size_flags_vertical = Control.SIZE_EXPAND_FILL
		stat.add_child(placeholder)

		var label = Label.new()
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.text = "Lorem Ipsum"
		label.visible = false
		stat.add_child(label)
	ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/Placeholder").visible = false

func unlock_stat(index: int) -> void:
	var stat = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/MarginContainer/Statistics")
	stat.get_child(1 + 2*index).visible = false
	stat.get_child(1 + 2*index + 1).visible = true
	stat.get_child(1 + 2*index + 1).text = "Click Power: %s" % click_power

	click_power_changed.connect(
		func(value: float): stat.get_child(1 + 2*index + 1).text = "Click Power: %s" % value
	)

func _on_ui_clicked(element: AnimatedTextureRect) -> void:
	if element != animated_texture:
		return

	current_power += click_power
	while current_power >= 1.0:
		current_power -= 1.0
		animated_texture.set_next_frame()

func _on_complete_circle() -> void:
	cultist_created.emit()

func click_power_add(amount: float):
	click_power += amount
	click_power_changed.emit(click_power)
