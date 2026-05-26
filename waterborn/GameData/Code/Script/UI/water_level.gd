extends Control

@onready var labels : Array = $Valves.get_children()
var labels_pos : Array

func _ready() -> void:
	for i in range(system_valve.zone_amount):
		labels_pos.append(labels[i].position.y)

func _process(_delta: float) -> void:
	for i in range(system_valve.zone_amount):
		labels[i].text = "Zone %d : %.1f" % [i + 1, system_valve.zone[i]]
		#labels[i].position.y = labels_pos[i] + 21
