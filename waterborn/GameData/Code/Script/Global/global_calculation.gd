extends Node

func two_position_to_distance(pos1, pos2) -> float:
	var pos = (pos1 - pos2).abs()
	var distance : float = sqrt(pos.x**2 + pos.y**2)
	return distance
