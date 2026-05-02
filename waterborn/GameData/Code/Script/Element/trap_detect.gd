extends Area3D

@export var spawnTab :Array[Node3D]
#relier le piège a un ou des marker 3D pour faire spawns le monstre 

var their_in = false
var new_position
var character
var monster = preload("res://GameData/Code/Scene/Character/Monster.tscn")


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		their_in = true
		character = body
		new_position = character.position
		print("dans la zone")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group('player'):
		their_in = false
		print("sort de la zone")

func _physics_process(delta: float) -> void:
	var distance = 0
	if their_in : 
		if(character.position - new_position).length() > 5 && !get_tree().get_nodes_in_group('enemies'):
			new_position = character.position
			var spawn = spawnTab.pick_random()
			var newMonster = monster.instantiate()
			get_tree().current_scene.add_child(newMonster)
			newMonster.global_position = spawn.global_position

			
			
		
