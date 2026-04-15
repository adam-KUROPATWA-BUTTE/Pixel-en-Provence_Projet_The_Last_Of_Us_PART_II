extends TextureButton

@onready var window = get_parent().get_parent().get_parent()

var hold : bool
var cursor_start_pos

func _process(_delta: float) -> void:
	if hold:
		window.position = Vector2i(get_viewport().get_mouse_position()) - Vector2i(cursor_start_pos) + window.window_pos

func _on_button_down() -> void:
	cursor_start_pos = get_viewport().get_mouse_position()
	hold = true

func _on_button_up() -> void:
	hold = false
	window.window_pos = Vector2i(get_viewport().get_mouse_position()) - Vector2i(cursor_start_pos) + window.window_pos
