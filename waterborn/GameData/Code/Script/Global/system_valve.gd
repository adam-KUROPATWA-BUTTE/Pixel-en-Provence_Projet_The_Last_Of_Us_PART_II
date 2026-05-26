extends Node

var zone : Array[float] = []
var zone_amount : int = 6
var rng = RandomNumberGenerator.new()
var wait : float = 0.0
var start_range : Vector2 = Vector2(18.0, 23.0)

var valve_open : Array[bool]
var nb_valve_open : int = 0
var flow : float = 1.0
var flow_rate_per_zone : float

var await_time : float = 1.0
var reduce_amount : float = 0.01

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
			var indiv_flow : float = flow_rate_per_zone * float(valve_open[i]) - reduce_amount
			zone[i] += indiv_flow

func valve_toggle(index : int, open : bool) -> void:
	valve_open[index] = open
	nb_valve_open += (-1 + int(open) * 2)
	calcul_flow()

func calcul_flow() -> void:
	if nb_valve_open != 0:
		var malus : int = 1
		if nb_valve_open >= zone_amount * 0.66:
			malus = 4
		elif nb_valve_open >= zone_amount * 0.5:
			malus = 3
		elif nb_valve_open >= zone_amount * 0.33:
			malus = 2
		flow_rate_per_zone = (flow/nb_valve_open) ** malus
	
