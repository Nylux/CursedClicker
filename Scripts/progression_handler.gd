# script to handle the progression system
# described how each unlockable node interact with the whole game
extends Node

func _ready() -> void:
	for node: UnlockableNode in FeaturesGraph.nodes:
		node.connect_unlocked(features_creation.bind(FeaturesGraph.nodes[node])) 

func features_creation(prog: FeaturesGraph.PROGRESSION) -> void:
	match prog:
		FeaturesGraph.PROGRESSION.RITUALS:
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/Control.visible = false
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/TemplateUi.visible = true
		FeaturesGraph.PROGRESSION.RITUALS_STAT:
			$/root/Game/RitualsHandler.unlock_title()
		FeaturesGraph.PROGRESSION.RITUALS_STAT_POWER:
			$/root/Game/RitualsHandler.unlock_stat(0)
			$/root/Game/RitualsHandler.unlock_button(0)
		FeaturesGraph.PROGRESSION.RITUALS_CLICK_POWER:
			$/root/Game/RitualsHandler.click_power_add(0.25)
		FeaturesGraph.PROGRESSION.ALTAR:
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/Control2.visible = false
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/TemplateUi2.visible = true
		_:
			push_error("Invalid feature %s" % prog)
