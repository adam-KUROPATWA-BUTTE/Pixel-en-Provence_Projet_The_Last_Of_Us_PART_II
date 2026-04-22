extends Node3D

@export var node_connection_distance : float = 6
@onready var threshold_square : float = node_connection_distance * node_connection_distance

var connections : Array = []
var time_to_process : float

func _ready() -> void:
	var start_time = Time.get_ticks_usec()
	print("path node connection ready")
	var nodes = get_children()
	
	for node in range(nodes.size()):
		for node_check in range (node + 1, nodes.size()):
			if nodes[node_check] != nodes[node] and !connections.has([nodes[node_check], nodes[node]]):
				#print(nodes[node], nodes[node].position, nodes[node_check], nodes[node_check].position)
				var node_distance = global_calculation.two_3d_position_to_distance_squared(nodes[node].position, nodes[node_check].position)
				if node_distance <= threshold_square:
					#print(global_calculation.two_3d_position_to_distance(node.position, check_node.position))
					#print("node base : ", node, "  node connected : ", check_node)
					connections.append([nodes[node], nodes[node_check]])
	print("connections : ", connections.size())
	var end_time = Time.get_ticks_usec()
	time_to_process = (end_time - start_time) / 1_000_000.0
	print("time to process pathfinding nodes = ", time_to_process, "s")
