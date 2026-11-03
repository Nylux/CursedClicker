class_name GameManager extends Node

var game_state: GameState
var game_ui: GameUI

func _ready() -> void:
	game_state = GameState.new()
	game_ui = GameUI.new(self)

	# it binds a state to an autoload, code smell if game is restarted
	# TODO: handle it better
	EventBus.data_changed.connect(UIHandler.resolve_ui.bind(game_state, game_ui))

	# links between data and ui
	game_ui.button_group.pressed.connect(_on_button_group_pressed.bind(game_state))

	
	var ritual = FeaturePanel.new().build(
		Utils.get_component(self, "TemplateUI0"),
		Utils.get_component(self, "PlaceholderUI0"),
		game_state.cultist_sacrificied.bind(game_state.click_multiplier),
		"Ritual",
		load("res://pentagram_animation.tres"),
		game_state,
	)
	FeaturesNode.rituals.connect_unlocked(ritual.activate)
	FeaturesNode.rituals_stat.connect_unlocked(ritual.unlock_title)
	FeaturesNode.rituals_stat_power.connect_unlocked(ritual.unlock_stat)
	FeaturesNode.rituals_improve_click1.connect_unlocked(ritual.click_power_add.bind(0.25))
	FeaturesNode.rituals_improve_click2.connect_unlocked(ritual.click_power_add.bind(0.25))
	FeaturesNode.rituals_improve_click3.connect_unlocked(ritual.click_power_add.bind(0.25))
	FeaturesNode.rituals_improve_click4.connect_unlocked(ritual.click_power_add.bind(0.25))
	FeaturesNode.rituals_improve_click5.connect_unlocked(ritual.click_power_add.bind(0.25))
	add_child(ritual)

	var altar = FeaturePanel.new().build(
		Utils.get_component(self, "TemplateUI1"),
		Utils.get_component(self, "PlaceholderUI1"),
		game_state.cultist_sacrificied.bind(game_state.click_multiplier),
		"Altar",
		load("res://altar_animation.tres"),
		game_state,
	)
	FeaturesNode.altar.connect_unlocked(altar.activate)
	add_child(altar)

	# first update
	GameApi.try_unlock_node(game_state, FeaturesNode.rituals)
	EventBus.data_changed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F12:
			GameApi.unlock_next_node(game_state)
		elif event.keycode == KEY_F11:
			GameApi.reset_game(game_state)


func _on_button_group_pressed(button: Button, gs: GameState) -> void:
	match button.name:
		"ButtonTimes1":
			gs.click_multiplier = 1
		"ButtonTimes10":
			gs.click_multiplier = 10
		"ButtonTimes100":
			gs.click_multiplier = 100
		"ButtonTimes1000":
			gs.click_multiplier = 1000
