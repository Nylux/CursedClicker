extends Node
	
var count_click: int = 0

func _ready() -> void:
	EventBus.clicked.connect(_on_ui_clicked)

func _on_ui_clicked(_ui: AnimatedTextureRect) -> void:
	count_click += 1
