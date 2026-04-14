extends NinePatchRect

@export var window_size : Vector2i = Vector2i(100, 70)

func _ready() -> void:
	size = window_size
