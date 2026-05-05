extends Node

var zone: Array[float] = []
var rng = RandomNumberGenerator.new()
var wait:float = 0.0

func _ready() -> void:
	for i in range(6):
		zone.append(rng.randf_range(15.0, 25.0))
		print(zone[i])

func _process(delta: float) -> void:
	wait += delta
	if wait >= 3.0: 
		wait = 0.0
		for i in range(6):
			zone[i] -= 2
			print(zone[i])
