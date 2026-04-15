extends Control

@onready var window_container : Control = $Windows
@onready var window_scene = preload("res://GameData/Code/Scene/UI/window.tscn")

var windows : Dictionary = {
	0 : {
		"size" : Vector2i(500, 300),
		"pos" : Vector2i(150, 180),
		"name" : "Default"
	},
	1 : {
		"size" : Vector2i(500, 300),
		"pos" : Vector2i(150, 180),
		"name" : "Godot"
	}
}

func load_window(window_id) -> void:
	if window_id == -1:
		return
	var new_window = window_scene.instantiate()
	new_window.window_size = windows[window_id]["size"]
	new_window.window_pos = windows[window_id]["pos"]
	new_window.window_name = windows[window_id]["name"]
	
	window_container.add_child(new_window)
	
