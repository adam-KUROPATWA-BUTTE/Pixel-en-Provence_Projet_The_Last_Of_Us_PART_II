extends Control

@onready var canvas_layer = get_parent()
@onready var player: CharacterBody3D = $"../../Player"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	canvas_layer.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if canvas_layer.visible:
			_resume()
		else:
			_pause()
		get_viewport().set_input_as_handled()

func _pause() -> void:
	get_tree().paused = true
	canvas_layer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _resume() -> void:
	get_tree().paused = false
	canvas_layer.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed() -> void:
	_resume()

func _on_option_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	GameManager.reset_runtime_data()
	get_tree().change_scene_to_file("res://GameData/Code/Scene/Menu/main_menu.tscn")
