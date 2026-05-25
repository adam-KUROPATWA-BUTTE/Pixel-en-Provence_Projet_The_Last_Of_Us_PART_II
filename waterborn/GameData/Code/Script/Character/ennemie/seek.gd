extends EnemyState

@export var search_time := 15.0
@export var searching_speed := 6.0
@export var search_radius := 10.0

var search_timer := 0.0
var player_last_seen_position: Vector3

func enter(_previous_state_name: String, data := {}) -> void:
	print("now seeking")
	if data["player_last_seen_position"]:
		player_last_seen_position = data["player_last_seen_position"]
	else:
		printerr("State 'Searching' was not given the player's last seen position through the data dictionary.")
		
	search_timer = search_time
	go_to_position_around_player_last_seen_position()

func update(delta: float) -> void:
	print("le monstre t'as perdu")
	search_timer -= delta
	if search_timer <= 0.0:
		print("le monstre disparais")
		monster_entity.queue_free()

func physics_update(_delta: float) -> void:
	# TODO n'a plus de navigation agent
	#if monster_entity.navigation_agent.is_navigation_finished():
		#go_to_position_around_player_last_seen_position()
	
	if not monster_entity.is_line_of_sight_broken():
		print("Chase")
		requested_transition_to_other_state.emit("Chase")

func go_to_position_around_player_last_seen_position() -> void:
	var random_position := player_last_seen_position + get_random_position_inside_circle(search_radius, player_last_seen_position.y)
	print("go around last place seen")
	monster_entity.travel_to_position(random_position, searching_speed)

func get_random_position_inside_circle(radius: float, height: float) -> Vector3:
	var theta: float = randf() * 2 * PI
	return Vector3(cos(theta), height, sin(theta)) * sqrt(randf()) * radius
