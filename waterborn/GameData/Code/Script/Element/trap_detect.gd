extends Area3D

var their_in = false
var new_position
var character

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
		if(character.position - new_position).length() > 5:
			new_position = character.position
			print("c'est déplacer")
		
