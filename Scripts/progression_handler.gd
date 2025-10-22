extends Node

func _ready() -> void:
	for node: UnlockableNode in FeaturesGraph.nodes:
		node.connect_unlocked(features_creation.bind(FeaturesGraph.nodes[node])) 

	# unlock rituals at start
	FeaturesGraph.unlock_node(FeaturesGraph.rituals)

func features_creation(prog: FeaturesGraph.PROGRESSION) -> void:
	match prog:
		FeaturesGraph.PROGRESSION.RITUALS:
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/Control.visible = false
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/TemplateUi.visible = true
			$/root/Game/RitualsHandler.on_ready()
		FeaturesGraph.PROGRESSION.RITUALS_STAT:
			$/root/Game/RitualsHandler.create_stats()
		FeaturesGraph.PROGRESSION.RITUALS_STAT_POWER:
			$/root/Game/RitualsHandler.unlock_stat(0)
		FeaturesGraph.PROGRESSION.RITUALS_CLICK_POWER:
			$/root/Game/RitualsHandler.click_power_add(0.25)
		FeaturesGraph.PROGRESSION.ALTAR:
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/Control2.visible = false
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/TemplateUi2.visible = true
		_:
			push_error("Invalid feature %s" % prog)
