extends Node

var zone: Array[float] = []
var rng = RandomNumberGenerator.new()
var wait:float = 0.0

var valve_open: Array[bool]
var flow: float = 10

var win_timer: float = 600.0
var timer:float = 0.0

func _ready() -> void:
	for i in range(6):
		zone.append(rng.randf_range(17.0, 25.0))
	for i in range(6):
		valve_open.append(false)

func _process(delta: float) -> void:
	wait += delta
	timer += delta
	if wait >= 3.0: 
		wait = 0.0
		for i in range(6):
			if zone[i] != 0:
				zone[i] -= 2
		recharge_zone()
		end_game()
		

func recharge_zone():
	var nb_valve_open = 0
	for i in range(6): 
		if valve_open[i] == true:
			nb_valve_open += 1
	if nb_valve_open != 0:
		var flow_rate_per_zone = flow/nb_valve_open
		for i in range(6): 
			if valve_open[i] == true and zone[i] != 100:
				zone[i] += flow_rate_per_zone	


func end_game(): 
	var nb = 0
	for i in range(6):
		if zone[i] <= 0 :
			nb += 1
			if nb >= 2 :
				GameManager.game_over()
	if (timer < win_timer):
		var all_filled =true
		for i in range(6):
			if zone[i] < 85.0:
				all_filled = false
				break
		if all_filled:
			print("open door") 	
