extends Node

class_name AltarHandler

@export var ui: SubViewportContainer
@export var title: String
@onready var tilte_node = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/VBoxContainer/Title")
@onready var animated_texture: AnimatedTextureRect = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect")
@onready var stat_container = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/MarginContainer")
@onready var stat_placeholder = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/Placeholder")
@onready var stat = stat_container.get_node("Statistics")

@export var n_stat: int = 1

func on_ready() -> void:
	# setup ui elements
	tilte_node.text = title
	EventBus.clicked.connect(_on_ui_clicked)

func create_stats():
	stat_container.visible = true
	
	# title for stats
	var stat_title = Label.new()
	stat_title.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stat_title.text = "Statistics"
	stat.add_child(stat_title)

	# stats elements
	for i in n_stat:
		var placeholder = Control.new()
		placeholder.size_flags_vertical = Control.SIZE_EXPAND_FILL
		stat.add_child(placeholder)

		var label = Label.new()
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.text = "Lorem Ipsum"
		label.visible = false
		stat.add_child(label)

	stat_placeholder.visible = false

func unlock_stat(index: int) -> void:
	stat.get_child(1 + 2*index).visible = false
	stat.get_child(1 + 2*index + 1).visible = true
	stat.get_child(1 + 2*index + 1).text = "Placeholder"

func _on_ui_clicked(element: AnimatedTextureRect) -> void:
	if element != animated_texture:
		return

	EventBus.cultist_sacrificied.emit(1)
