extends Node3D

@onready var debug_texture : MeshInstance3D = $DebugTexture
@export var entry : bool = false

#you'll need to assign these in the editor
@export var mat : StandardMaterial3D
@export var col : Color

func _ready() -> void:
	var mater = mat.duplicate()
	var mesh_copy = debug_texture.mesh.duplicate()
	if debug_texture:
		debug_texture.visible = global_variable.full_debug
		if entry:
			mater.albedo_color = col
		mesh_copy.surface_set_material(0, mater)
		debug_texture.mesh = mesh_copy
			
			#mater.albedo_color = col
			#debug_texture.mesh.surface_set_material(0, mater)
