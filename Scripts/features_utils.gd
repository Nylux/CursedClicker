class_name FeaturesUtils extends RefCounted

static func create_stats(container: Control, placeholder: Control, stat_amount: int):
	container.visible = true
	var stat = container.get_node("Statistics")
	
	# title for stats
	var stat_title = Label.new()
	stat_title.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stat_title.text = "Statistics"
	stat_title.visible = false
	stat.add_child(stat_title)

	# stats elements
	for i in stat_amount:
		var control = Control.new()
		control.size_flags_vertical = Control.SIZE_EXPAND_FILL
		stat.add_child(control)

		var label = Label.new()
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.text = "Lorem Ipsum"
		label.visible = false
		stat.add_child(label)

	placeholder.visible = false

static func create_upgrades_button(container: Control, button_amount: int) -> void:
	for i in button_amount:
		var btn = Button.new()
		btn.text = "Lorem Ipsum"
		btn.visible = false
		container.add_child(btn)


static func unlock_title(ui: TemplateUI) -> void:
	ui.stat.get_child(0).visible = true


static func unlock_stat(ui: TemplateUI, index: int) -> void:
	ui.stat.get_child(1 + 2*index).visible = false
	ui.stat.get_child(1 + 2*index + 1).visible = true
	ui.stat.get_child(1 + 2*index + 1).text = "Placeholder"


static func activate(ui: TemplateUI, ui_placeholder: Control) -> void:
	ui.visible = true
	ui_placeholder.visible = false
