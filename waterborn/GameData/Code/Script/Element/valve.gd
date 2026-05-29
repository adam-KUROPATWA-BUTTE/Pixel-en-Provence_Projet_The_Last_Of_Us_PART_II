extends Node

@export_range(1, 6) var zone_index: int = 1
var is_open: bool = false

func interact():
	is_open = !is_open
	print("valve :", self, " is now open with id : ", zone_index)
	system_valve.valve_toggle(zone_index-1, is_open)


func _on_pressed() -> void:
	interact()
