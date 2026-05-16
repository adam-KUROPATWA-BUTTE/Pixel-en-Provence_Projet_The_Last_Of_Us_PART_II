extends Node3D

## Passive Pathfinding var
@export var node_connection_distance : float = 2.5

var connections : Array = []
var time_to_process : float
var nodes : Array[Node]

## Active Pathfinding var
var astar: AStar3D = AStar3D.new()

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
		if node.entry:
			pathfinding.entry_nodes.append(node)
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
	await build_astar_grid()
	print("time to process pathfinding nodes = ", time_to_process, "s")
	print(astar)

func build_astar_grid():
	for connection in connections:
		if !astar.has_point(nodes.find(connection[0])):
			astar.add_point(nodes.find(connection[0]), connection[0].position)
		if !astar.has_point(nodes.find(connection[1])):
			astar.add_point(nodes.find(connection[1]), connection[1].position)
		astar.connect_points(nodes.find(connection[0]), nodes.find(connection[1]), true)
	pathfinding.astar = astar
	pathfinding.astar_ready = true
