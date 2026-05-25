extends Area3D

var their_in = false
var new_position
var character

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		character = body
		character.speed = character.speed/3
		print("dans la zone")



func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group('player'):
		character.speed = character.speed*3
		print("sort de la zone")
		
