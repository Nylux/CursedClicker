class_name FeaturePanel extends Node


var ui: TemplateUI
var ui_placeholder: Control
var ui_callback: Callable
var stat_amount: int = 1

var game_state: GameState


func build(
	p_ui: TemplateUI,
	p_ui_placeholder: Control,
	p_ui_callback,
	p_title: String,
	p_sprites: SpriteFrames,
	p_game_state: GameState
) -> FeaturePanel:
	ui = p_ui
	ui.animated_texture.setup(p_sprites)
	ui_placeholder = p_ui_placeholder
	ui_callback = p_ui_callback
	game_state = p_game_state

	ui.title_node.text = p_title
	ui.animated_texture.setup(p_sprites)
	EventBus.clicked.connect(_on_ui_clicked)
	FeaturesUtils.create_stats(ui.stat_container, ui.stat_placeholder, stat_amount)

	return self


func unlock_title() -> void:
	ui.stat.get_child(0).visible = true


func unlock_stat(index: int) -> void:
	if index >= stat_amount:
		return
	ui.stat.get_child(1 + 2*index).visible = false
	ui.stat.get_child(1 + 2*index + 1).visible = true
	ui.stat.get_child(1 + 2*index + 1).text = "Placeholder"


func _on_ui_clicked(element: AnimatedTextureRect) -> void:
	if element != ui.animated_texture:
		return

	if ui_callback:
		ui_callback.call()


func activate() -> void:
	ui.visible = true
	ui_placeholder.visible = false
