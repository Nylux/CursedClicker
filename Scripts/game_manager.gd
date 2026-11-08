class_name GameManager extends Node

var game_state: GameState
var game_ui: GameUI

var ritual_timer: Timer

func _ready() -> void:
	game_state = GameState.new()

	var ritual = RitualPanel.new(
		Utils.get_component(self, "TemplateUI0"),
		Utils.get_component(self, "PlaceholderUI0"),
		"Ritual",
		load("res://pentagram_animation.tres"),
	)
	add_child(ritual)

	ritual_timer = Timer.new()
	ritual_timer.timeout.connect(game_state.progress_ritual)
	add_child(ritual_timer)
	ritual_timer.start(1.)

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
