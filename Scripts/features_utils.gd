extends RefCounted

class_name FeaturesUtils

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
