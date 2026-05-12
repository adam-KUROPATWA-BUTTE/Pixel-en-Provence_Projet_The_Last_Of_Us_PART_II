extends Control

@onready var labels : Array = [$VBoxContainer/Label, $VBoxContainer/Label2, $VBoxContainer/Label3, $VBoxContainer/Label4, $VBoxContainer/Label5, $VBoxContainer/Label6]

func _process(_delta: float) -> void:
	for i in range(6):
		labels[i].text = "Zone %d : %.1f" % [i + 1, SystemeValve.zone[i]]
