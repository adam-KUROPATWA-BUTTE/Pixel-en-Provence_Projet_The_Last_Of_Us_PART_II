extends EnemyState

@export var update_path_delay := 0.0 # if you do not want to update the path every physics frame, increase this
@export var _chasing_speed := 6.0
@export var _catching_distance := 1.8

var _end_chase := 0.0
var _update_path_timer := 0.0


func enter(previous_state_name: String, data := {}) -> void:
	_end_chase = randf_range(60.0, 100.0)


func update(delta: float) -> void:
	_update_path_timer -= delta
	_end_chase -= delta
	if _end_chase <= 0.0:
		print("disparais")
		_monster.queue_free()

func physics_update(_delta: float) -> void:
	if _update_path_timer <= 0.0:
		_update_path_timer = update_path_delay
		_monster.travel_to_position(_monster.player.global_position, _chasing_speed)
	
	if  _monster.is_line_of_sight_broken():
		requested_transition_to_other_state.emit("Searching", {"player_last_seen_position":_monster.player.global_position})
	
	if _monster.global_position.distance_to(_monster.player.global_position) <= _catching_distance:
		_monster.reached_player.emit()
