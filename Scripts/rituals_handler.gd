extends Node

class_name RitualsHandler

signal click_power_changed(value)

@export var ui: SubViewportContainer
@export var title: String
@onready var tilte_node = ui.get_node("SubViewport/Panel/VBoxContainer/MarginContainer/Title")
@onready var animated_texture: AnimatedTextureRect = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect")
@onready var stat_container = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/MarginContainer")
@onready var stat_placeholder = ui.get_node("SubViewport/Panel/VBoxContainer/HBoxContainer/Placeholder")
@onready var upgrade_container = ui.get_node("SubViewport/Panel/VBoxContainer/Upgrades/MarginContainer/GridContainer")

var click_power: float = 0.5
var current_power: float = 0.0
@export var stat_amount: int = 1
@export var button_amount: int = 1

func _ready() -> void:
	# unlock rituals at start
	FeaturesGraph.unlock_node(FeaturesGraph.rituals)
	# setup ui elements
	tilte_node.text = title
	EventBus.clicked.connect(_on_ui_clicked)
	animated_texture.complete_circle.connect(_on_complete_circle)

	# setup internal logic
	current_power = 0.0
	FeaturesUtils.create_stats(stat_container, stat_placeholder, stat_amount)
	FeaturesUtils.create_upgrades_button(upgrade_container, button_amount)

func unlock_title() -> void:
	var stat = stat_container.get_node("Statistics")
	stat.get_child(0).visible = true

func unlock_stat(index: int) -> void:
	var stat = stat_container.get_node("Statistics")
	stat.get_child(1 + 2*index).visible = false
	var lbl: Label = stat.get_child(1 + 2*index + 1)
	lbl.visible = true

	match index:
		0:
			lbl.text = "Click Power: %s" % click_power
			click_power_changed.connect(_on_stat1_changed.bind(lbl))
		_:
			push_error("hihi")

func unlock_button(index: int) -> void:
	var btn: Button = upgrade_container.get_child(index)
	btn.visible = true
	
	match index:
		0:
			btn.text = "rituals improve click"
			btn.pressed.connect(_on_button1_pressed.bind(btn))
		_:
			push_error("hihi")

func _on_ui_clicked(element: AnimatedTextureRect) -> void:
	if element != animated_texture:
		return

	current_power += click_power
	while current_power >= 1.0:
		current_power -= 1.0
		animated_texture.set_next_frame()

func _on_complete_circle() -> void:
	EventBus.cultist_created.emit(1)

func click_power_add(amount: float):
	click_power += amount
	click_power_changed.emit(click_power)

func _on_button1_pressed(btn: Button): 
	FeaturesGraph.rituals_improve_click1.connect_unlocked(
		func(): btn.visible = false
	)
	FeaturesGraph.unlock_node(FeaturesGraph.rituals_improve_click1)

func _on_stat1_changed(value: float, lbl: Label):
	lbl.text = "Click Power: %s" % value
