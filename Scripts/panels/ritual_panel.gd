class_name RitualPanel extends Node

var ui: TemplateUI
var ui_placeholder: Control
var worker_label: Label
var worker_slider: HSlider

var stat_amount: int = 1


func _init(
	p_ui: TemplateUI,
	p_ui_placeholder: Control,
	p_title: String,
	p_sprites: SpriteFrames,
) -> void:
	ui = p_ui
	ui_placeholder = p_ui_placeholder
	ui.title_node.text = p_title
	ui.animated_texture.setup(p_sprites)


func _ready() -> void:
	# unlock rituals at start
	FeaturesNode.rituals.connect_unlocked(FeaturesUtils.activate.bind(ui, ui_placeholder))

	# setup internal logic
	FeaturesUtils.create_stats(ui.stat_container, stat_amount)

	worker_label = Label.new()
	worker_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui.upgrade_container.add_child(worker_label)

	worker_slider = HSlider.new()
	worker_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui.upgrade_container.add_child(worker_slider)


func resolve_ui(workers: int, worker_frac: float, cultists: int, data: RitualData) -> void:
	worker_label.text = "Workers: %s / %s" % [workers, cultists]
	worker_slider.set_value_no_signal(worker_frac)
	ui.animated_texture.set_frame(data.cur_progress)
