extends Node3D

@export var node_connection_distance : float = 6
@onready var threshold_square : float = node_connection_distance * node_connection_distance

var connections : Array = []
var time_to_process : float

func _ready() -> void:
	var start_time = Time.get_ticks_usec()
	print("path node connection ready")
	var nodes : Array[Node] = get_children()
	
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
	print("time to process pathfinding nodes = ", time_to_process, "s")
