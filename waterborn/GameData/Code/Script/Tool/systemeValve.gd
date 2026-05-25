extends Node

var zone: Array[float] = []
var rng = RandomNumberGenerator.new()
var wait:float = 0.0

var valve_open: Array[bool]
var flow: float = 10


func _ready() -> void:
	for i in range(6):
		zone.append(rng.randf_range(15.0, 25.0))
	for i in range(6):
		valve_open.append(false)

func _process(delta: float) -> void:
	wait += delta
	if wait >= 8.0: 
		wait = 0.0
		for i in range(6):
			zone[i] -= 2
		recharge_zone()

func recharge_zone():
	var nb_valve_open = 0
	for i in range(6): 
		if valve_open[i] == true:
			nb_valve_open += 1
	if nb_valve_open != 0:
		var flow_rate_per_zone = flow/nb_valve_open
		for i in range(6): 
			if valve_open[i] == true:
				zone[i] += flow_rate_per_zone	
