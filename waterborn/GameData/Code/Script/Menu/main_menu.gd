extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed() -> void:
	GameManager.goto_scene("res://GameData/Code/Scene/Map/Test.tscn")

func _on_option_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
