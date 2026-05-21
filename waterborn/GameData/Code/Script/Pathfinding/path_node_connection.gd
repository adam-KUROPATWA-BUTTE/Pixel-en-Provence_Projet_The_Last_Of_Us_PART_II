extends Node3D

@export var node_connection_distance : float = 2.5
var global_id : int
var connections : Array = []
var time_to_process : float
var nodes : Array[Node]
var astar: AStar3D = AStar3D.new()

func _ready() -> void:
	global_id = str(self).to_int()
	var start_time = Time.get_ticks_usec()
	nodes = get_children()
	
	var threshold_square : float = node_connection_distance ** 2
	
	var node_index : Dictionary = {}
	for i in range(nodes.size()):
		node_index[nodes[i]] = i + global_id
	
	var grid : Dictionary = {}
	var seen : Dictionary = {}
	
	for node in nodes:
		if node.entry:
			pathfinding.entry_nodes.append([node, node_index[node], global_id])
		var cell = Vector3i(
			floori(node.global_position.x / node_connection_distance),
			floori(node.global_position.y / node_connection_distance),
			floori(node.global_position.z / node_connection_distance)
		)
		if not grid.has(cell):
			grid[cell] = []
		grid[cell].append(node)
	
	grid_to_connections(grid, node_index, seen, threshold_square)
	
	var end_time = Time.get_ticks_usec()
	time_to_process = (end_time - start_time) / 1_000_000.0
	build_astar_grid()

func grid_to_connections(grid : Dictionary, node_index : Dictionary, seen : Dictionary, threshold_square : float) -> void:
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
							var id_a : int = node_index[node]
							var id_b : int = node_index[check_node]
							if id_a > id_b:
								var key = Vector2i(id_b, id_a)
								if seen.has(key):
									continue
								seen[key] = true
							else:
								var key = Vector2i(id_a, id_b)
								if seen.has(key):
									continue
								seen[key] = true
							
							if global_calculation.two_3d_position_to_distance_squared(
									node.global_position, check_node.global_position) <= threshold_square:
								connections.append([node_index[node], node_index[check_node], 
									node.global_position, check_node.global_position])

func build_astar_grid() -> void:
	for connection in connections:
		var id_a : int = connection[0]
		var id_b : int = connection[1]
		if !astar.has_point(id_a):
			astar.add_point(id_a, connection[2])
		if !astar.has_point(id_b):
			astar.add_point(id_b, connection[3])
		astar.connect_points(id_a, id_b, true)
	pathfinding.add_astar(astar)
