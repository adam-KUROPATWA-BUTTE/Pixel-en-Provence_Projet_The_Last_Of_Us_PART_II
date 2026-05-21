extends Node

## Active Pathfinding var 
var in_process : Array = []
var astar_ready : bool = false
var astar: AStar3D = AStar3D.new()
var start : Vector3
var target : Vector3

var entry_nodes : Array
var node_threshold : float = 2.8 ** 2

var start_time
var printed : bool = false

func _process(_delta: float) -> void:
	if start_time != 0 and !printed and astar_ready:
		print((Time.get_ticks_usec() - start_time) / 1_000_000.0)
		printed = true

func add_astar(new_astar : AStar3D) -> void:
	astar_ready = false
	if start_time == null:
		start_time = Time.get_ticks_usec()
	var id = Time.get_ticks_usec()
	in_process.append(id)
	if astar.get_point_count() == 0:
		astar = new_astar
	else:
		for point_id in new_astar.get_point_ids():
			if not astar.has_point(point_id):
				astar.add_point(point_id, new_astar.get_point_position(point_id))
				astar.set_point_weight_scale(point_id, new_astar.get_point_weight_scale(point_id))
		for point_id in new_astar.get_point_ids():
			for neighbor_id in new_astar.get_point_connections(point_id):
				if not astar.are_points_connected(point_id, neighbor_id):
					astar.connect_points(point_id, neighbor_id)
	
	in_process.erase(id)
	#print(in_process)
	#print("amount remaining at add_astar : ", in_process.size() + entry_nodes.size())
	if in_process.size() + entry_nodes.size() == 0:
		astar_ready = true
	connect_room_by_entry()

func connect_room_by_entry() -> void:
	var connected : Array = []
	
	for entry_node in entry_nodes:
		var best_match = null
		var best_distance : float = INF
		for exit_node in entry_nodes:
			if entry_node == exit_node or entry_node[2] == exit_node[2] or connected.has(entry_node) or connected.has(exit_node):
				continue
			var distance = global_calculation.two_3d_position_to_distance_squared(entry_node[0].global_position, exit_node[0].global_position)
			
			if distance <= node_threshold and distance < best_distance:
				best_distance = distance
				best_match = exit_node
		if best_match != null:
			if !astar.has_point(entry_node[1]):
				astar.add_point(entry_node[1],entry_node[0].global_position)
			if !astar.has_point(best_match[1]):
				astar.add_point(best_match[1],best_match[0].global_position)
			astar.connect_points(entry_node[1], best_match[1], true)
			
			if !connected.has(entry_node):
				connected.append(entry_node)
			if !connected.has(best_match):
				connected.append(best_match)
	
	for node in connected:
		entry_nodes.erase(node)
	#print(entry_nodes)
	#for node in entry_nodes:
		#print("node position : ", node[0].global_position)
	
	#print("amount remaining at connect_entry : ", in_process.size() + entry_nodes.size())
	if in_process.size() + entry_nodes.size() == 0:
		astar_ready = true

func get_astar_path(imported_start: Vector3, imported_target: Vector3) -> PackedVector3Array:
	if !astar_ready:
		print("astar path not ready, try again later")
		return PackedVector3Array()
	
	var sid : int = astar.get_closest_point(imported_start)
	var tid : int = astar.get_closest_point(imported_target)
	# Validate AStar points before accessing their positions
	if not astar.has_point(sid) or not astar.has_point(tid):
		print("Invalid start or target point")
		return PackedVector3Array()

	start = Vector3(astar.get_point_position(sid))
	target = Vector3(astar.get_point_position(tid))
	if astar.get_point_connections(sid).is_empty():
		print("Start point has no connections")
		return PackedVector3Array()
	if astar.get_point_connections(tid).is_empty():
		print("Target point has no connections")
		return PackedVector3Array()

	var raw_path : PackedVector3Array = astar.get_point_path(sid, tid)

	if raw_path.size() < 1:
		print("Path too short: ", raw_path)
		return PackedVector3Array()

	var scaled_path : PackedVector3Array = PackedVector3Array()
	for path in raw_path:
		scaled_path.append(path)
	return scaled_path
