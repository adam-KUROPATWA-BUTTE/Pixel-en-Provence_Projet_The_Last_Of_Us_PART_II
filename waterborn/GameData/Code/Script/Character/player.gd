extends CharacterBody3D

@export var speed : float = 6.0
@export var mouse_sensitivity : float = 0.003
@export var toglable : bool

@onready var camera = $head/Camera3D

func die() : 
	print("You Died")

func _try_interact():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		camera.global_position,
		camera.global_position + (-camera.global_transform.basis.z * 2.0)  # 2m de portée
	)
	var result = space.intersect_ray(query)
	if result and result.collider.has_method("interact"):
		result.collider.interact()
