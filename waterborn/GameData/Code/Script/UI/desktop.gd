extends Control

@onready var window_container : Control = $Windows
@onready var error_container : Control = $Errors
@onready var window_scene = preload("res://GameData/Code/Scene/UI/window.tscn")
@onready var error_scene = preload("res://GameData/Code/Scene/UI/error.tscn")

@export var duplicate_window : bool = false

var windows : Dictionary = {
	0 : {
		"size" : Vector2i(500, 300),
		"pos" : Vector2i(150, 180),
		"name" : "Default",
		"content" : null
	},
	1 : {
		"size" : Vector2i(500, 300),
		"pos" : Vector2i(150, 180),
		"name" : "Godot",
		"content" : null
	},
	2 : {
		"size" : Vector2i(278, 258),
		"pos" : Vector2i(512, 96),
		"name" : "Sandwich Archive",
		"content" : preload("res://GameData/Code/Scene/UI/WindowContent/sandwich_content.tscn")
	},
	3 : {
		"size" : Vector2i(278, 258),
		"pos" : Vector2i(512, 96),
		"name" : "Bimont Archive",
		"content" : null
	},
	4 : {
		"size" : Vector2i(280, 150),
		"pos" : Vector2i(640, 288),
		"name" : "Archives",
		"content" : preload("res://GameData/Code/Scene/UI/WindowContent/archives_folder_content.tscn")
	}
}

var errors: Dictionary = {
	0 : {
		"size" : Vector2i(150, 90),
		"pos" : Vector2i(900, 470),
		"name" : "Your computer have a virus",
		"content" : null
	},
	1 : {
		"size" : Vector2i(150, 90),
		"pos" : Vector2i(900, 470),
		"name" : "Restricted Access",
		"content" : null
	}
}

func _process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("Left"):
	#	load_window(0, "error")

func load_window(window_id, type) -> void:
	if window_id == -1:
		return
	var new_window
	var dico : Dictionary
	var container : Control
	match type:
		global_enums.window_types.WINDOW:
			dico = windows
			container = window_container
			new_window = window_scene.instantiate()
		global_enums.window_types.ERROR:
			dico = errors
			container = error_container
			new_window = error_scene.instantiate()
		_:
			return
	if dico:
		for window in container.get_children():
			if window.window_name == dico[window_id]["name"] and !duplicate_window and type != global_enums.window_types.ERROR:
				return
		new_window.window_name = dico[window_id]["name"]
		new_window.window_size = dico[window_id]["size"]
		new_window.window_pos  = dico[window_id]["pos"]
		if dico[window_id]["content"] != null:
			new_window.window_content  = dico[window_id]["content"]
	
		container.add_child(new_window)
