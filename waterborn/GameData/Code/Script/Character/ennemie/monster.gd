extends CharacterBody3D
class_name monster

signal reached_player

@export var max_spotting_distance := 50.0

var _current_speed := 0.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player : Node3D
@onready var eye: Node3D = $eye
@onready var eye_ray_cast: RayCast3D = $eye/RayCast3D


func _ready() -> void:
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	player = get_tree().get_first_node_in_group('player')
	#reached_player.connect(func(): player.die())

func _process(_delta: float) -> void:
	if !is_moving and global_target:
		is_moving = true
		done = await try_go_to(global_target)
		if !done:
			print("something went wrong :(")
		is_moving = false
		global_target = null

func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_position := navigation_agent.get_next_path_position()
	
	var where_to_look := next_path_position
	where_to_look.y = global_position.y
	if not where_to_look.is_equal_approx(global_position):
		# if you want interpolation, look into quaternions and slerp()
		# I'm just using look_at for simplicity
		look_at(where_to_look)
	
	var direction := next_path_position - global_position
	direction.y = 0.0
	direction = direction.normalized()
	velocity = direction * _current_speed
	move_and_slide()


func travel_to_position(wanted_position: Vector3, speed: float) -> void:
	navigation_agent.target_position = wanted_position
	_current_speed = speed


func is_player_in_view() -> bool:
	#print("check for player")
	if !player:
		return false
	
	var vec_to_player := (player.global_position - global_position)
	
	if vec_to_player.length() > max_spotting_distance:
		return false
	
	var in_fov := -eye.global_basis.z.normalized().dot(vec_to_player.normalized()) > 0.3
	
	if in_fov:
		return not is_line_of_sight_broken()
	
	return false


func is_line_of_sight_broken() -> bool:
	if !player:
		return true
	
	eye_ray_cast.target_position = eye_ray_cast.to_local(player.global_position) + Vector3(0, 1.8, 0)
	eye_ray_cast.force_raycast_update()
	return eye_ray_cast.is_colliding()


func try_go_to(destination : Vector3) -> bool:
	print("start trying")
	if !pathfinding.astar_ready:
		print("astar not ready yet")
		return false
	await go_to(destination)
	return true

func go_to(destination : Vector3) -> void:
	current_target = global_target
	path = pathfinding.get_astar_path(global_position, destination)
	last_direction = global_calculation.two_3d_position_to_distance(global_position, destination)
	
	if path.size() == 0:
		print("AStar path empty, cannot move to ", destination)
		return
	
	if global_calculation.two_3d_position_to_distance(global_position, path[0]) >= global_calculation.two_3d_position_to_distance(global_position, destination):
		path = [destination]
	
	await move_to()
	
	if path_index == path.size():
		var at_destination : bool = false
		while (!at_destination):
			var to_target : Vector3 = destination - global_position
			
			if to_target.length() < arrive_threshold:
				at_destination = true
			
			var dir := to_target.normalized()
			last_direction = direction
			direction = dir
			direction_to_velocity()
			
			await (Engine.get_main_loop() as SceneTree).process_frame
			if not is_instance_valid(self):
				return
	velocity = Vector3.ZERO
	direction = Vector3.ZERO
	return

func move_to() -> void:
	path_index = 0
	var previous_pos : Vector3 = global_position
	var time_at_same_place : float = 0
	
	while (path_index < path.size() and time_at_same_place < 40 and global_target == current_target) :
		if previous_pos == global_position:
			time_at_same_place += 1
		else:
			time_at_same_place = 0
		previous_pos = global_position
		
		var target : Vector3= path[path_index]
		var to_target : Vector3 = target - global_position
		
		if to_target.length() < arrive_threshold:
			path_index += 1
			continue
		
		var where_to_look : Vector3 = target
		where_to_look.y = global_position.y
		if not where_to_look.is_equal_approx(global_position):
			# if you want interpolation, look into quaternions and slerp()
			# I'm just using look_at for simplicity
			look_at(where_to_look)
		
		var dir := to_target.normalized()
		last_direction = direction
		direction = dir
		direction_to_velocity()
		
		await (Engine.get_main_loop() as SceneTree).process_frame
		if not is_instance_valid(self):
			return
	
	#check why pathfinding ended
	print(
		"reason of end pathfinding : path_size = ",
		!(path_index < path.size()), ", time at same place = ",!(time_at_same_place < 40), 
		", target changed = ", !(global_target == current_target))
	
	velocity = Vector3.ZERO
	direction = Vector3.ZERO
	current_target = null
	if time_at_same_place >= 40:
		print("cannot move for to long")
	return

func direction_to_velocity() -> void:
	if abs(direction.x) > 0 and abs(direction.y) > 0:
		direction *= 0.70710678
	var current_speed : float = speed * (run_multiplier if is_running else 1.0)
	velocity = direction * current_speed
	move_and_slide()
