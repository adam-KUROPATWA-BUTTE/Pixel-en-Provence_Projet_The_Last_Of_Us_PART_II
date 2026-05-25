extends Area3D

@export var spawnTab :Array[Node3D]
#relier le piège a un ou des marker 3D pour faire spawns le monstre 

var their_in : bool = false
var new_position : Vector3
var character : Node3D
var distance : float
var monster_entity : Resource = preload("res://GameData/Code/Scene/Character/Monster.tscn")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		their_in = true
		character = body
		new_position = character.position

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group('player'):
		their_in = false

func _physics_process(_delta: float) -> void:
	if their_in : 
		distance = (character.position - new_position).length()
		if distance > 5.0 && !get_tree().get_nodes_in_group('enemies'):
			new_position = character.position
			var spawn = spawnTab.pick_random()
			var newMonster = monster_entity.instantiate()
			get_tree().current_scene.add_child(newMonster)
			newMonster.global_position = spawn.global_position
