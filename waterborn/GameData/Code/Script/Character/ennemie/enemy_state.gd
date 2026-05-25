extends Node
class_name EnemyState

@warning_ignore("unused_signal")
signal requested_transition_to_other_state(target_state_name: String, data: Dictionary)

@warning_ignore("unused_private_class_variable")
@onready var _monster: monster = owner

func enter(_previous_state_name: String, _data := {}) -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
