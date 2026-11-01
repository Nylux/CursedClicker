class_name UIHandler extends Node


static func resolve_ui(game_state: GameState, game_ui: GameUI) -> void:
	game_ui.blood_label.text ="%s" %  game_state.current_blood
	game_ui.corruption_label.text ="%s" %  game_state.current_corruption
	game_ui.population_label.text ="%s" %  game_state.current_population
	game_ui.cultist_label.text = "%s" % game_state.current_cultist
	game_ui.zealot_label.text = "%s" % game_state.current_zealot
	game_ui.infiltrator_label.text = "%s" % game_state.current_infiltrator
