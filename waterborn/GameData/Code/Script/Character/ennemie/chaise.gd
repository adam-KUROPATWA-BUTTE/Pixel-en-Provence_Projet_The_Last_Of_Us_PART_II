extends EnemyState

@export var update_path_delay := 1.0
@export var chasing_speed := 60.0 # 6.0
@export var catching_distance := 1.8

var end_chase := 0.0
var update_path_timer := 0.0

func enter(_previous_state_name: String, _data := {}) -> void:
	print("now chasing")
	end_chase = randf_range(60.0, 100.0)


func update(delta: float) -> void:
	update_path_timer -= delta
	end_chase -= delta
	if end_chase <= 0.0:
		print("le monstre disparais après un chasse très longue")
		monster_entity.queue_free()

func physics_update(_delta: float) -> void:
	if update_path_timer <= 0.0:
		update_path_timer = update_path_delay
		print("go to player")
		monster_entity.travel_to_position(monster_entity.player.global_position, chasing_speed)
	
	if  monster_entity.is_line_of_sight_broken():
		requested_transition_to_other_state.emit("Searching", {"player_last_seen_position":monster_entity.player.global_position})
	
	if monster_entity.global_position.distance_to(monster_entity.player.global_position) <= catching_distance:
		monster_entity.reached_player.emit()
