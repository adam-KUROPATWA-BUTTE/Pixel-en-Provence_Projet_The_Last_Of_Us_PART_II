extends Node

var zone: Array[float] = []
var zone_amount : int = 6
var rng = RandomNumberGenerator.new()
var wait : float = 0.0
var start_range : Vector2 = Vector2(15.0, 25.0)

var valve_open: Array[bool]
var flow: float = 10

var await_time : float = 4.0
var reduce_amount : float = 1.0

func _ready() -> void:
	for i in range(zone_amount):
		zone.append(rng.randf_range(start_range.x, start_range.y))
	for i in range(zone_amount):
		valve_open.append(false)

func _process(delta: float) -> void:
	wait += delta
	if wait >= await_time: 
		wait = 0.0
		for i in range(zone_amount):
			zone[i] -= reduce_amount
		recharge_zone()

func recharge_zone():
	var nb_valve_open = 0
	for i in range(zone_amount): 
		if valve_open[i] == true:
			nb_valve_open += 1
	if nb_valve_open != 0:
		var flow_rate_per_zone = flow/nb_valve_open
		for i in range(zone_amount): 
			if valve_open[i] == true:
				zone[i] += flow_rate_per_zone
