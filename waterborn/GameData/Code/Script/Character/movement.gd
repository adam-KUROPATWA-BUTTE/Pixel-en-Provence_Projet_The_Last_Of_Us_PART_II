extends CharacterBody3D

@export var speed: float = 8.0
@export var mouse_sensitivity: float = 0.003
@export var toglable : bool

var head: Node3D
var pitch: float = 0.0

var cam_time = 0.0
var cam_amplitude= 0.08
var cam_freq = 7.0

func _ready() -> void:
	head = $head
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if toglable:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			pitch = clamp(pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-89), deg_to_rad(89))
			head.rotation.x = pitch

func _physics_process(delta: float) -> void:
	
	if toglable:
		var direction = Vector3.ZERO
		var forward = -transform.basis.z
		var right = transform.basis.x
		
		if Input.is_action_pressed('Forward'):
			direction += forward
		elif Input.is_action_pressed("Backward"):
			direction -= forward
		elif Input.is_action_pressed("Right"):
			direction += right
		elif  Input.is_action_pressed("Left"):
			direction -= right
		if direction != Vector3.ZERO :
			cam_time += cam_freq*delta
			head.position.y = sin(cam_time) * cam_amplitude	
			direction = direction.normalized()
			if (Input.is_action_pressed("run")):
				velocity.x = direction.x * (speed*1.3)
				velocity.z = direction.z * (speed*1.)
				cam_time += 0.08
			else:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed	

			move_and_slide()
		else :
			lerp(head.position.y, 0.0, 0.1)
			
func die() : 
	print("tu es mort")
