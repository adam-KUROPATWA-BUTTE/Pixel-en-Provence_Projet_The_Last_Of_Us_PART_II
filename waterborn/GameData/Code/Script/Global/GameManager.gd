extends Node

var player_position: Vector3
var zone: Array[float] = []
var valve_open: Array[bool] = []
var timer: float = 0.0

func reset_runtime_data() -> void:
	zone.clear()
	valve_open.clear()
	timer = 0.0
	player_position = Vector3.ZERO

func goto_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func game_over() -> void:
	get_tree().change_scene_to_file("res://GameData/Code/Scene/Menu/game-over.tscn")
