extends CharacterBody3D
class_name monster

signal reached_player

@export var max_spotting_distance := 50.0

var _current_speed := 0.0
var global_target
var current_target
var path : PackedVector3Array
var path_index : int

var direction
var last_direction
var arrive_threshold = 0.2

var speed : int = 3 # range (3min, 30max)
var run_multiplier : float = 2.0
var is_running : bool = false

var is_moving : bool = false
var done : bool = false

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player : Node3D
@onready var _eye: Node3D = $eye
@onready var _eye_ray_cast: RayCast3D = $eye/RayCast3D

func _ready() -> void:
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	player = get_tree().get_first_node_in_group('player')
	reached_player.connect(func(): player.die())

func _process(_delta: float) -> void:
	if !is_moving:
		is_moving = true
		done = await try_go_to(global_target)
		if !done:
			print("something went wrong :(")
		is_moving = false

func travel_to_position(wanted_position: Vector3, import_speed: float) -> void:
	global_target = wanted_position
	_current_speed = import_speed

func is_player_in_view() -> bool:
	if !player:
		return false
	
	var vec_to_player := (player.global_position - global_position)
	
	if vec_to_player.length() > max_spotting_distance:
		return false
	
	var in_fov := -_eye.global_basis.z.normalized().dot(vec_to_player.normalized()) > 0.3
	
	if in_fov:
		return not is_line_of_sight_broken()
	
	return false

func is_line_of_sight_broken() -> bool:
	if !player:
		return true
	
	_eye_ray_cast.target_position = _eye_ray_cast.to_local(player.global_position)
	_eye_ray_cast.force_raycast_update()
	return _eye_ray_cast.is_colliding()


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
