extends Node3D

## Passive Pathfinding var
@export var node_connection_distance : float = 6

var connections : Array = []
var time_to_process : float
var nodes : Array[Node]

## Active Pathfinding var
var astar: AStar3D = AStar3D.new()
var start : Vector3
var target : Vector3

func _ready() -> void:
	var start_time = Time.get_ticks_usec()
	print("path node connection ready")
	nodes = get_children()
	
	var threshold_square : float = node_connection_distance * node_connection_distance
	
	var node_index = {}
	for i in range(nodes.size()):
		node_index[nodes[i]] = i
	
	var grid : Dictionary = {}
	var seen : Dictionary = {}
	
	for node in nodes:
		var cell = Vector3i(
		floori(node.position.x / node_connection_distance),
		floori(node.position.y / node_connection_distance),
		floori(node.position.z / node_connection_distance)
	)
		if not grid.has(cell):
			grid[cell] = []
		grid[cell].append(node)
	
	for cell in grid.keys():
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				for dz in [-1, 0, 1]:
					var neighbor_cell = cell + Vector3i(dx, dy, dz)
					if not grid.has(neighbor_cell):
						continue
					for node in grid[cell]:
						for check_node in grid[neighbor_cell]:
							if node == check_node:
								continue
							
							var id_a = node_index[node]
							var id_b = node_index[check_node]
							var key = Vector2i(min(id_a, id_b), max(id_a, id_b))
							if seen.has(key):
								continue
							seen[key] = true
							
							var diff = node.position - check_node.position
							if diff.dot(diff) <= threshold_square:
								connections.append([node, check_node])
	
	print("connections : ", connections.size())
	var end_time = Time.get_ticks_usec()
	time_to_process = (end_time - start_time) / 1_000_000.0
	build_astar_grid()
	print("time to process pathfinding nodes = ", time_to_process, "s")
	print(astar)

#func _draw() -> void:
	#if astar == null and (path.size() == 0 or path == null or path.is_empty() and !debug):
		#return
#
	#if (path.size() == 0 or path == null or path.is_empty()):
		#for id in astar.get_point_ids():
			#var connections = astar.get_point_connections(id)
			##if debug:
				##for lid in connections:
					##draw_line(
						##Vector2(
						##(astar.get_point_position(id).x*cell_size), 
						##(astar.get_point_position(id).y*cell_size)), 
						##Vector2(
						##(astar.get_point_position(lid).x*cell_size), 
						##(astar.get_point_position(lid).y*cell_size)), 
						 ##Color.WHITE, 2.0)
		#for id in astar.get_point_ids():
			#var pos = Vector2(
					#(astar.get_point_position(id).x*cell_size), 
					#(astar.get_point_position(id).y*cell_size))
			##if debug:
				##draw_circle(pos, 4.0, Color.BLUE)
#
	## Draw current path in red
	##if debug:
		##for point in path:
			##draw_circle(point, 4.0, Color.RED)
		##for i in range(path.size() - 1):
			##draw_line(path[i], path[i + 1], Color.RED, 2.0)	
		##if start:
			##draw_circle(start, 4.0, Color.YELLOW)
		##if target:
			##draw_circle(target, 4.0, Color.GREEN)

func build_astar_grid():
	for connection in connections:
		if !astar.has_point(nodes.find(connection[0])):
			astar.add_point(nodes.find(connection[0]), connection[0].position)
		if !astar.has_point(nodes.find(connection[1])):
			astar.add_point(nodes.find(connection[1]), connection[1].position)
		astar.connect_points(nodes.find(connection[0]), nodes.find(connection[1]), true)

func get_astar_path(imported_start: Vector3, imported_target: Vector3) -> PackedVector3Array:
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
