extends CharacterBody3D

var path
var path_index : int

var direction
var last_direction
var arrive_threshold = 0.2

var speed : int = 3 # range (3min, 30max)
var run_multiplier : float = 2.0
var is_running : bool = false

var is_moving : bool = false
var done : bool = false

func _process(_delta: float) -> void:
	#move to 0, 0 to test pathfinding
	if !is_moving:
		is_moving = true
		done = await try_go_to(Vector3(0, 0, 0))
		if done:
			print("done :)")
		else:
			print("something went wrong :(")
			is_moving = false

func try_go_to(destination : Vector3) -> bool:
	print("start trying")
	if !pathfinding.astar_ready:
		print("astar not ready yet")
		return false
	await go_to(destination)
	return true

func go_to(destination : Vector3) -> void:
	path = pathfinding.get_astar_path(global_position, destination)
	last_direction = global_calculation.two_3d_position_to_distance(global_position, destination)
	
	if path.size() == 0:
		print("AStar path empty, cannot move to ", destination)
		return
	
	await move_to()
	
	
	
	if path_index == path.size():
		print("last step")
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

func move_to() -> void: #TODO split function, too long
	path_index = 0
	var previous_pos : Vector3 = global_position
	var time_at_same_place : int = 0
	
	while (path_index < path.size() and time_at_same_place < 40) :
		if Vector3i(previous_pos) == Vector3i(global_position):
			time_at_same_place += 1
		else:
			time_at_same_place = 0
		previous_pos = global_position
		
		var target : Vector3= path[path_index]
		var to_target : Vector3 = target - global_position
		
		if to_target.length() < arrive_threshold:
			path_index += 1
			continue

		var dir := to_target.normalized()
		last_direction = direction
		direction = dir
		direction_to_velocity()
		
		await (Engine.get_main_loop() as SceneTree).process_frame
		if not is_instance_valid(self):
			return
	
	velocity = Vector3.ZERO
	direction = Vector3.ZERO
	if time_at_same_place >= 40:
		print("cannot move for to long")
	return

func direction_to_velocity() -> void:
	if abs(direction.x) > 0 and abs(direction.y) > 0:
		direction *= 0.70710678
	var current_speed : float = speed * (run_multiplier if is_running else 1.0)
	velocity = direction * current_speed
	move_and_slide()
