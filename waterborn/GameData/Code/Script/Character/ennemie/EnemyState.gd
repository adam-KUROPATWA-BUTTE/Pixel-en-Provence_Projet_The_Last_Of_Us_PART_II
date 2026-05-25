extends Node
class_name EnemyState

signal requested_transition_to_other_state(target_state_name: String, data: Dictionary)

@warning_ignore("unused_private_class_variable")
@onready var monster_entity : monster = owner

func enter(previous_state_name: String, data := {}) -> void:
	pass
func exit() -> void:
	pass
func update(_delta: float) -> void:
	pass
func physics_update(_delta: float) -> void:
	pass
