extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_retry_pressed() -> void:
	GameManager.goto_scene("res://GameData/Code/Scene/Map/Test.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://GameData/Code/Scene/Menu/main_menu.tscn")
