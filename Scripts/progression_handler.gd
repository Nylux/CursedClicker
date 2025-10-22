extends Node

func _ready() -> void:
	# core features
	
	## rituals
	FeaturesGraph.rituals.connect_unlocked(features_creation.bind(0))
	FeaturesGraph.altar.connect_unlocked(features_creation.bind(4))
	
	# subfeatures
	
	## rituals
	FeaturesGraph.rituals_stat.connect_unlocked(features_creation.bind(1))
	FeaturesGraph.rituals_stat_power.connect_unlocked(features_creation.bind(2))
	
	# upgrades
	
	## rituals
	FeaturesGraph.rituals_improve_click1.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click2.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click3.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click4.connect_unlocked(features_creation.bind(3))
	FeaturesGraph.rituals_improve_click5.connect_unlocked(features_creation.bind(3))

func features_creation(index: int) -> void:
	match index:
		0:
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/Control.visible = false
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/TemplateUi.visible = true
			$/root/Game/RitualsHandler.on_ready()
		1:
			$/root/Game/RitualsHandler.create_stats()
		2:
			$/root/Game/RitualsHandler.unlock_stat(0)
		3:
			$/root/Game/RitualsHandler.click_power_add(0.25)
		4:
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/Control2.visible = false
			$/root/Game/CanvasLayer/VBoxContainer/GridContainer/TemplateUi2.visible = true
		_:
			push_error("Invalid feature %s" % index)
