extends StaticBody3D

@export var door : AnimatableBody3D

func interact():
	door.open()
