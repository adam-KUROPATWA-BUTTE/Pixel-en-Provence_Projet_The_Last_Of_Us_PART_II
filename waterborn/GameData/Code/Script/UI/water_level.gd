extends Control

@onready var labels : Array = $VBoxContainer.get_children()

func _process(_delta: float) -> void:
	for i in range(system_valve.zone_amount):
		labels[i].text = "Zone %d : %.1f" % [i + 1, system_valve.zone[i]]
