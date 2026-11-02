class_name AltarHandler extends Node


var ui: TemplateUI
var title: String
var sprites: SpriteFrames
var stat_amount: int = 1

var game_state: GameState

func _ready() -> void:
	ui.title_node.text = title
	ui.animated_texture.setup(sprites)
	EventBus.cultist_changed.connect(_on_cultist_changed)
	EventBus.clicked.connect(_on_ui_clicked)

func create_stats():
	ui.stat_container.visible = true
	
	# title for stats
	var stat_title = Label.new()
	stat_title.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stat_title.text = "Statistics"
	ui.stat.add_child(stat_title)

	# stats elements
	for i in stat_amount:
		var placeholder = Control.new()
		placeholder.size_flags_vertical = Control.SIZE_EXPAND_FILL
		ui.stat.add_child(placeholder)

		var label = Label.new()
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.text = "Lorem Ipsum"
		label.visible = false
		ui.stat.add_child(label)

	ui.stat_placeholder.visible = false

func unlock_stat(index: int) -> void:
	if index >= stat_amount:
		return
	ui.stat.get_child(1 + 2*index).visible = false
	ui.stat.get_child(1 + 2*index + 1).visible = true
	ui.stat.get_child(1 + 2*index + 1).text = "Placeholder"

func _on_cultist_changed(amount: int) -> void:
	if amount >= 1:
		FeaturesGraph.unlock_node(FeaturesGraph.altar)
		EventBus.cultist_changed.disconnect(_on_cultist_changed)


func _on_ui_clicked(element: AnimatedTextureRect) -> void:
	if element != ui.animated_texture:
		return
	EventBus.sacrifice_created.emit(game_state.click_multiplier)
