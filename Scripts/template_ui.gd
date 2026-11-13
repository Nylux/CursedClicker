class_name TemplateUI extends SubViewportContainer

var title: String
var title_node: Label
var stat_container: MarginContainer
var stat: VBoxContainer
var animated_texture: AnimatedTextureRect
var upgrade_container: GridContainer

func _ready() -> void:
	title_node = Utils.get_component(self, "Title")
	stat_container = Utils.get_component(self, "StatContainer")
	stat = Utils.get_component(self, "Statistics")
	animated_texture = Utils.get_component(self, "AnimatedTexture")
	upgrade_container = Utils.get_component(self, "UpgradeContainer")
