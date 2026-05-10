extends AnimatableBody3D

var is_moving: bool = false
var timer: float = 0.0
var closed_pos : Vector3
@export var open_height : float = 3.0
@export var move_duration : float = 1.0
@export var open_duration : float = 2.0

func _ready() -> void:
	closed_pos = position
	
func open():
	if is_moving:
		return
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", closed_pos + Vector3(0, open_height, 0), move_duration)
	await tween.finished
	await get_tree().create_timer(open_duration).timeout
	close()

func close():
	var twen = create_tween()
	twen.tween_property(self, "position", closed_pos, move_duration)
	await twen.finished
	is_moving = false
	
	
