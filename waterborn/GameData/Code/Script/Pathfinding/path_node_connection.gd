extends Node3D

## Passive Pathfinding var
@export var node_connection_distance : float = 2.5

var global_id : int
var connections : Array = []
var time_to_process : float
var nodes : Array[Node]

## Active Pathfinding var
var astar: AStar3D = AStar3D.new()

func _ready() -> void:
	global_id = str(self).to_int()
	
	var start_time = Time.get_ticks_usec()
	nodes = get_children()
	
	var threshold_square : float = node_connection_distance ** 2
	
	var node_index : Dictionary = {}
	for i in range(nodes.size()):
		node_index[nodes[i]] = i
	
	var grid : Dictionary = {}
	var seen : Dictionary = {}
	
	for node in nodes:
		if node.entry:
			pathfinding.entry_nodes.append([node, nodes.find(node)+global_id, global_id])
		var cell = Vector3i(
		floori(node.global_position.x / node_connection_distance),
		floori(node.global_position.y / node_connection_distance),
		floori(node.global_position.z / node_connection_distance)
	)
		if not grid.has(cell):
			grid[cell] = []
		grid[cell].append(node)
	
	grid_to_connections(grid, node_index, seen, threshold_square)
	
	#print("connections : ", connections.size())
	var end_time = Time.get_ticks_usec()
	time_to_process = (end_time - start_time) / 1_000_000.0
	await build_astar_grid()
	#print("time to process pathfinding nodes = ", time_to_process, "s")

func grid_to_connections(grid : Dictionary, node_index : Dictionary, seen : Dictionary, threshold_square : float):
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
							
							#var diff = global_calculation.two_3d_position_to_distance_squared(node.global_position, check_node.global_position)
							if global_calculation.two_3d_position_to_distance_squared(node.global_position, check_node.global_position) <= threshold_square:
								connections.append([node, check_node])

func build_astar_grid():
	for connection in connections:
		if !astar.has_point(nodes.find(connection[0])+global_id):
			astar.add_point(nodes.find(connection[0])+global_id, connection[0].global_position)
		if !astar.has_point(nodes.find(connection[1])+global_id):
			astar.add_point(nodes.find(connection[1])+global_id, connection[1].global_position)
		astar.connect_points(nodes.find(connection[0])+global_id, nodes.find(connection[1])+global_id, true)
	pathfinding.add_astar(astar)
	#pathfinding.astar = astar
	#pathfinding.astar_ready = true
