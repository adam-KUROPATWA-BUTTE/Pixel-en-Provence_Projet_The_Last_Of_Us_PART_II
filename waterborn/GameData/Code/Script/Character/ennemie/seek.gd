extends EnemyState

@export var search_time := 15.0
@export var _searching_speed := 6.0
@export var _search_radius := 10.0

var _search_timer := 0.0
var _player_last_seen_position: Vector3


func enter(previous_state_name: String, data := {}) -> void:
	if data["player_last_seen_position"]:
		_player_last_seen_position = data["player_last_seen_position"]
	else:
		printerr("State 'Searching' was not given the player's last seen position through the data dictionary.")
		
	_search_timer = search_time
	_go_to_position_around_player_last_seen_position()


func update(delta: float) -> void:
	print("ta perdu")
	_search_timer -= delta
	if _search_timer <= 0.0:
		print("disparais")
		_monster.queue_free()


func physics_update(_delta: float) -> void:
	if _monster.navigation_agent.is_navigation_finished():
		_go_to_position_around_player_last_seen_position()
	
	if not _monster.is_line_of_sight_broken():
		print("Chase")
		requested_transition_to_other_state.emit("Chase")


func _go_to_position_around_player_last_seen_position() -> void:
	var random_position := _player_last_seen_position + _get_random_position_inside_circle(_search_radius, _player_last_seen_position.y)
	_monster.travel_to_position(random_position, _searching_speed)


func _get_random_position_inside_circle(radius: float, height: float) -> Vector3:
	var theta: float = randf() * 2 * PI
	return Vector3(cos(theta), height, sin(theta)) * sqrt(randf()) * radius
