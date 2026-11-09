class_name GameManager extends Node

var game_state: GameState
var game_ui: GameUI

var ticked_timer: Timer

func _ready() -> void:
	game_state = GameState.new()

	var ritual = RitualPanel.new(
		Utils.get_component(self, "TemplateUI0"),
		Utils.get_component(self, "PlaceholderUI0"),
		"Ritual",
		load("res://pentagram_animation.tres"),
	)
	add_child(ritual)

	var infiltration = InfiltrationPanel.new(
		Utils.get_component(self, "TemplateUI1"),
		Utils.get_component(self, "PlaceholderUI1"),
		"Infiltration",
	)
	add_child(infiltration)

	var covert = CovertPanel.new(
		Utils.get_component(self, "TemplateUI2"),
		Utils.get_component(self, "PlaceholderUI2"),
		"Covert",
	)
	add_child(covert)

	ticked_timer = Timer.new()
	ticked_timer.timeout.connect(_game_resolve)
	add_child(ticked_timer)
	ticked_timer.start(1.)

	game_ui = GameUI.new(self, ritual)

	# it binds a state to an autoload, code smell if game is restarted
	# TODO: handle it better
	EventBus.data_changed.connect(UIHandler.resolve_ui.bind(game_state, game_ui))

	# links between data and ui
	game_ui.button_group.pressed.connect(_on_button_group_pressed.bind(game_state))
	game_ui.ritual_panel.worker_slider.value_changed.connect(game_state.set_ritual_workers)
	game_ui.ritual_panel.worker_slider.value_changed.connect(func(_value: float): EventBus.data_changed.emit())

	# first update
	GameApi.try_unlock_node(game_state, FeaturesNode.rituals)
	GameApi.try_unlock_node(game_state, FeaturesNode.infiltration)
	GameApi.try_unlock_node(game_state, FeaturesNode.covert)
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


func _game_resolve() -> void:
	game_state.progress_ritual()

	for i: int in game_state.countries:
		if i == GameData.PLAYER_ID:
			continue
		print(ActionHandler.compute(game_state.countries, game_state.relations, game_state.weights, i))
