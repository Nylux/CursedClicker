extends Node

class_name BloodHandler

@onready var statistics_container: VBoxContainer = $/root/Game/CanvasLayer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer

var current_blood: int

func _ready() -> void:

	# handles new cultist created
	EventBus.blood_created.connect(_on_blood_created)

	# ui setup
	current_blood = 0
	update_ui()

func _on_blood_created(value: int):
	# update ui
	current_blood += value
	update_ui()

func update_ui() -> void:
	var current_blood_label: Label = statistics_container.get_node("HBoxBlood/CurrentBloodLabel")
	current_blood_label.text ="%s" %  current_blood
