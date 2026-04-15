extends NinePatchRect

@export var window_size : Vector2i = Vector2i(100, 70)
@export var window_pos : Vector2i = Vector2i(150, 180)
@export var window_name : String = "Text"

@onready var name_label : Label = $WindowTopBar/WindowName

func _ready() -> void:
	size = window_size
	position = window_pos
	name_label.text = window_name
