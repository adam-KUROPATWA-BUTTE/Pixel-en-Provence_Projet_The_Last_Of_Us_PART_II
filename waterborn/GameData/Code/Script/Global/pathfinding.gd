extends Node

var in_process : Array = []
var astar_ready : bool = false
var astar: AStar3D = AStar3D.new()
var start : Vector3
var target : Vector3
var entry_nodes : Array
var node_threshold : float = 2.8 ** 2
var start_time = null
var printed : bool = false

func _process(_delta: float) -> void:
	if start_time != null and !printed and astar_ready:
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
		var new_ids : PackedInt64Array = new_astar.get_point_ids()
		for point_id in new_ids:
			if not astar.has_point(point_id):
				astar.add_point(point_id, new_astar.get_point_position(point_id))
				astar.set_point_weight_scale(point_id, new_astar.get_point_weight_scale(point_id))
		for point_id in new_ids:
			for neighbor_id in new_astar.get_point_connections(point_id):
				if point_id < neighbor_id:
					astar.connect_points(point_id, neighbor_id)
	
	in_process.erase(id)
	if in_process.size() == 0:
		astar_ready = true
	connect_room_by_entry()

func connect_room_by_entry() -> void:
	if entry_nodes.is_empty():
		return
	
	var connected_set : Dictionary = {}
	var size : int = entry_nodes.size()
	
	for i in range(size):
		var entry_node = entry_nodes[i]
		if connected_set.has(i):
			continue
		
		var best_match_idx : int = -1
		var best_distance : float = INF
		var entry_pos : Vector3 = entry_node[0].global_position
		var entry_room = entry_node[2]
		
		for j in range(size):
			if i == j or connected_set.has(j):
				continue
			var exit_node = entry_nodes[j]
			if entry_room == exit_node[2]:
				continue
			
			var distance : float = global_calculation.two_3d_position_to_distance_squared(
				entry_pos, exit_node[0].global_position)
			if distance <= node_threshold and distance < best_distance:
				best_distance = distance
				best_match_idx = j
		
		if best_match_idx != -1:
			var best_match = entry_nodes[best_match_idx]
			if !astar.has_point(entry_node[1]):
				astar.add_point(entry_node[1], entry_node[0].global_position)
			if !astar.has_point(best_match[1]):
				astar.add_point(best_match[1], best_match[0].global_position)
			astar.connect_points(entry_node[1], best_match[1], true)
			connected_set[i] = true
			connected_set[best_match_idx] = true
	
	var indices : Array = connected_set.keys()
	indices.sort()
	indices.reverse()
	for idx in indices:
		entry_nodes.remove_at(idx)
	
	if in_process.size() + entry_nodes.size() == 0:
		astar_ready = true

func get_astar_path(imported_start: Vector3, imported_target: Vector3) -> PackedVector3Array:
	if !astar_ready:
		print("astar path not ready, try again later")
		return PackedVector3Array()
	
	var sid : int = astar.get_closest_point(imported_start)
	var tid : int = astar.get_closest_point(imported_target)
	
	if not astar.has_point(sid) or not astar.has_point(tid):
		print("Invalid start or target point")
		return PackedVector3Array()
	
	start = astar.get_point_position(sid)
	target = astar.get_point_position(tid)
	
	if astar.get_point_connections(sid).is_empty():
		print("Start point has no connections")
		return PackedVector3Array()
	if astar.get_point_connections(tid).is_empty():
		print("Target point has no connections")
		return PackedVector3Array()
	
	return astar.get_point_path(sid, tid)
