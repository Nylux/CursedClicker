extends Node

class_name BloodHandler

@onready var statistics_container: GridContainer = $/root/Game/CanvasLayer/VBoxContainer/HBoxContainer/MarginContainer/ResourceContainer

var current_blood: int
var current_coruption: int

func _ready() -> void:

	EventBus.blood_created.connect(_on_blood_created)
	EventBus.corruption_created.connect(_on_corruption_created)

	# ui setup
	current_blood = 0
	update_ui()

func _on_blood_created(value: int):
	# update ui
	current_blood += value
	update_ui()

func _on_corruption_created(value: int):
	# update ui
	current_blood += value
	update_ui()

func update_ui() -> void:
	var current_blood_label: Label = statistics_container.get_node("HBoxBlood/BloodLabel")
	current_blood_label.text ="%s" %  current_blood
	var current_corruption_label: Label = statistics_container.get_node("HBoxCorruption/CorruptionLabel")
	current_corruption_label.text ="%s" %  current_coruption
