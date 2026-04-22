extends Node

## Active Pathfinding var
var astar_ready : bool = false
var astar: AStar3D = AStar3D.new()
var start : Vector3
var target : Vector3

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
