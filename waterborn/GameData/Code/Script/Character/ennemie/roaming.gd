extends EnemyState

@export var roaming_speed := 2.0

@warning_ignore("unused_private_class_variable")
var target_position: Vector3
var nav_map : RID
var roaming_distance : float = 10.0
var check_delay : float = 0.5
var last_check : float = 0.0

#func ready() -> void:
	#await get_tree().physics_frame
	#await get_tree().physics_frame
	# TODO n'a plus de navigation agent
	#nav_map = monster_entity.get_world_3d().get_navigation_map()

func enter(_previous_state_name: String, _data := {}) -> void:
	print("now roaming")
	if !pathfinding.astar_ready:
		return
	
	if monster_entity.global_target == null:
		travel_to_random_position()

func physics_update(delta: float) -> void:
#func _process(delta: float) -> void:
	if !pathfinding.astar_ready:
		return
	
	if monster_entity.global_target == null:
		travel_to_random_position()
	
	if last_check >= check_delay:
		if monster_entity.is_player_in_view():
			print("player seen")
			monster_entity.global_target = null
			requested_transition_to_other_state.emit("Chase")
		last_check = 0.0
	else:
		last_check += delta

func travel_to_random_position() -> void:
	var rand_pos : Vector3 = (monster_entity.global_position) + global_calculation.distance_to_random_vector3(roaming_distance)
	var rand_destination : Vector3 = pathfinding.astar.get_point_position(pathfinding.astar.get_closest_point(rand_pos))
	#var rand_pos := NavigationServer3D.map_get_random_point(nav_map, 1, true)
	print("go to random position")
	monster_entity.travel_to_position(rand_destination, roaming_speed)
