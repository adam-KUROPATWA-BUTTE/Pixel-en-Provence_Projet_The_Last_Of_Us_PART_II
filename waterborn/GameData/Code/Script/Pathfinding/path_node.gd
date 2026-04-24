extends Node3D

@onready var debug_texture : MeshInstance3D = $DebugTexture

func _process(_delta: float) -> void:
	debug_texture.visible = global_variable.full_debug
