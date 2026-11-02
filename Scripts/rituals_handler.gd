extends Node

class_name RitualsHandler

signal click_power_changed(value)

var ui: TemplateUI
var title: String
var sprites: SpriteFrames
var ui_placeholder: Control

var click_power: float = 0.5
var current_power: float = 0.0
var stat_amount: int = 1
var button_amount: int = 1

var stat_index: int = 0
var unlock_index: int = 0

var game_state: GameState

func _ready() -> void:
	# unlock rituals at start
	FeaturesGraph.rituals.connect_unlocked(func():
		ui.visible = true
		ui_placeholder.visible = false)
	FeaturesGraph.rituals_stat.connect_unlocked(unlock_title)
	FeaturesGraph.rituals_stat_power.connect_unlocked(func():
		unlock_stat()
		unlock_button())
	FeaturesGraph.rituals_improve_click1.connect_unlocked(func():
		click_power_add(0.25)
		unlock_button()
	)
	FeaturesGraph.rituals_improve_click2.connect_unlocked(func():
		click_power_add(0.25)
		unlock_button()
	)
	FeaturesGraph.rituals_improve_click3.connect_unlocked(func():
		click_power_add(0.25)
		unlock_button()
	)
	FeaturesGraph.rituals_improve_click4.connect_unlocked(func():
		click_power_add(0.25)
		unlock_button()
	)
	FeaturesGraph.rituals_improve_click5.connect_unlocked(func():
		click_power_add(0.25)
		unlock_button()
	)

	FeaturesGraph.unlock_node(FeaturesGraph.rituals)
	# setup ui elements
	ui.title_node.text = title
	ui.animated_texture.setup(sprites)
	ui.animated_texture.complete_circle.connect(_on_complete_circle)
	EventBus.clicked.connect(_on_ui_clicked)

	# setup internal logic
	current_power = 0.0
	FeaturesUtils.create_stats(ui.stat_container, ui.stat_placeholder, stat_amount)
	FeaturesUtils.create_upgrades_button(ui.upgrade_container, button_amount)

func unlock_title() -> void:
	var stat = ui.stat_container.get_node("Statistics")
	stat.get_child(0).visible = true

func unlock_stat() -> void:
	var stat = ui.stat_container.get_node("Statistics")
	stat.get_child(1 + 2*stat_index).visible = false
	var lbl: Label = stat.get_child(1 + 2*stat_index + 1)
	lbl.visible = true

	match stat_index:
		0:
			lbl.text = "Click Power: %s" % click_power
			click_power_changed.connect(_on_stat1_changed.bind(lbl))
		_:
			push_error("hihi")

	stat_index += 1


func unlock_button() -> void:
	var btn: Button = ui.upgrade_container.get_child(0)
	btn.visible = true
	btn.text = "rituals improve click"

	match unlock_index:
		0:
			btn.pressed.connect(func(): FeaturesGraph.unlock_node(FeaturesGraph.rituals_improve_click1))
		1:
			btn.pressed.connect(func(): FeaturesGraph.unlock_node(FeaturesGraph.rituals_improve_click2))
		2:
			btn.pressed.connect(func(): FeaturesGraph.unlock_node(FeaturesGraph.rituals_improve_click3))
		3:
			btn.pressed.connect(func(): FeaturesGraph.unlock_node(FeaturesGraph.rituals_improve_click4))
		4:
			btn.pressed.connect(func(): FeaturesGraph.unlock_node(FeaturesGraph.rituals_improve_click5))
		_:
			push_error("hihi")

	unlock_index += 1

func _on_ui_clicked(element: AnimatedTextureRect) -> void:
	if element != ui.animated_texture:
		return

	current_power += click_power
	while current_power >= 1.0:
		current_power -= 1.0
		ui.animated_texture.set_next_frame()

func _on_complete_circle() -> void:
	game_state.cultist_created.emit(1)

func click_power_add(amount: float):
	click_power += amount
	click_power_changed.emit(click_power)

func _on_stat1_changed(value: float, lbl: Label):
	lbl.text = "Click Power: %s" % value
