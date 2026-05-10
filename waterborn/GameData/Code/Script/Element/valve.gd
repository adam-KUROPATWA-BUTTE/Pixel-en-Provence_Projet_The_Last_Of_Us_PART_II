extends StaticBody3D

@export var zone_index: int = 0
var is_open: bool = false
func interact():
	is_open = !is_open
	SystemeValve.valve_open[zone_index] = is_open
