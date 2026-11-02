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

	var ritual = RitualsHandler.new()
	ritual.ui = Utils.get_component(self, "TemplateUi")
	ritual.title = "Ritual"
	ritual.game_state = game_state
	ritual.sprites = load("res://pentagram_animation.tres")
	add_child(ritual)

	var altar = AltarHandler.new()
	altar.ui = Utils.get_component(self, "TemplateUi2")
	altar.title = "Altar"
	altar.game_state = game_state
	altar.sprites = load("res://altar_animation.tres")
	add_child(altar)

	# first update
	EventBus.data_changed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F12:
			FeaturesGraph.unlock_next_node()


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
