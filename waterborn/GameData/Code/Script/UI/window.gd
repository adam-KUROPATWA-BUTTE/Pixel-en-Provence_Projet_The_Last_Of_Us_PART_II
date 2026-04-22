extends NinePatchRect

@export var window_size : Vector2i = Vector2i(100, 70)
@export var window_pos : Vector2i = Vector2i(150, 180)
@export var window_name : String = "Text"

var window_content

@onready var name_label : Label = $WindowTopBar/WindowName
@onready var content_container : Control = $WindowContentContainer
@onready var window_container = get_parent()

func _ready() -> void:
	size = window_size
	name_label.text = window_name
	
	if window_container != null and window_container is Control:
		for window in window_container.get_children():
			if window != self:
				if global_calculation.two_2d_position_to_distance(Vector2i(window.position), window_pos) <= 8:
					window_pos += Vector2i(16, 16)
		position = window_pos
	
	if window_content != null:
		print(window_content)
		content_container.add_child(window_content.instantiate())
