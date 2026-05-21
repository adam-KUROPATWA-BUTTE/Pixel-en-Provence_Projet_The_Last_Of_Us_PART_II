extends Node3D

@onready var debug_texture : MeshInstance3D = $DebugTexture
@export var entry : bool = false

func _ready() -> void:
	if debug_texture:
		debug_texture.visible = global_variable.full_debug
