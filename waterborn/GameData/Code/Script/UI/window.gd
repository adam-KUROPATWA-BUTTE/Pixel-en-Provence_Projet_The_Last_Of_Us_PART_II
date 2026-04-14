extends NinePatchRect

@export var window_size : Vector2i = Vector2i(100, 70)
@export var pos : Vector2i = Vector2i(150, 180)

func _ready() -> void:
	size = window_size
	position = pos
