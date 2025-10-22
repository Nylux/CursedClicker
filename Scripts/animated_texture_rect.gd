# extention of TextureRect to enable animation in a control
extends TextureRect

class_name AnimatedTextureRect

signal complete_circle

@export var sprites: SpriteFrames
@export var current_animation: String = "default"
@export var frame_index: int = 0

func _ready() -> void:
	if sprites != null:
		texture = sprites.get_frame_texture(current_animation, frame_index)

func set_next_frame() -> void:
	if sprites == null:
		return
	frame_index += 1
	var frame_count = sprites.get_frame_count(current_animation)

	if frame_index >= frame_count:
		complete_circle.emit()
		frame_index = 0
	
	texture = sprites.get_frame_texture(current_animation, frame_index)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			EventBus.clicked.emit(self)
