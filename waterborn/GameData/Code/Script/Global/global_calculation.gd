extends Node

#use sqrt() so can be slow if use in to many iterations
func two_2d_position_to_distance(pos1 : Vector2, pos2 : Vector2) -> float:
	var pos : Vector2 = (pos1 - pos2).abs()
	var distance : float = sqrt(pos.x**2 + pos.y**2)
	return distance

#better for iterations
func two_2d_position_to_distance_squared(pos1 : Vector2, pos2 : Vector2) -> float:
	var pos : Vector2 = (pos1 - pos2).abs()
	var distance_square : float = pos.x**2 + pos.y**2
	return distance_square

#use sqrt() so can be slow if use in to many iterations
func two_3d_position_to_distance(pos1 : Vector3, pos2 : Vector3) -> float:
	var pos : Vector3 = (pos1 - pos2).abs()
	var distance : float = sqrt(pos.x**2 + pos.y**2 + pos.z**2)
	return distance

#better for iterations
func two_3d_position_to_distance_squared(pos1 : Vector3, pos2 : Vector3) -> float:
	var pos : Vector3 = (pos1 - pos2).abs()
	var distance_square : float = pos.x**2 + pos.y**2 + pos.z**2
	return distance_square
