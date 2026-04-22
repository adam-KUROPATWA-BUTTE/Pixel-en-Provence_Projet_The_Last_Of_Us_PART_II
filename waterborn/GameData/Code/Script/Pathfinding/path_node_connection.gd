extends Node3D

func _ready() -> void:
	print("path node connection ready")
	for node in get_children():
		print(node)
