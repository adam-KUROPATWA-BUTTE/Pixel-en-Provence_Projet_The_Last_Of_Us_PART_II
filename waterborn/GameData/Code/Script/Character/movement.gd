extends CharacterBody3D

@export var speed: float = 6.0
@export var mouse_sensitivity: float = 0.003
#@export var gravity: float = 9.8
@export var toglable : bool

@onready var head: Node3D = $head
var pitch: float = 0.0

var cam_bas_pos : float
var cam_time : float = 0.0
var cam_amplitude : float = 0.08
var cam_freq : float = 7.0

func _ready() -> void:
	cam_bas_pos = head.position.y
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
			head.position.y = cam_bas_pos + (sin(cam_time) * cam_amplitude)
			direction = direction.normalized()
			if (Input.is_action_pressed("run")):
				velocity.x = direction.x * (speed*1.5)
				velocity.z = direction.z * (speed*1.5)
				cam_time += 0.08
			else:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed

			#if not is_on_floor():
			#	velocity.y -= gravity * delta	

			move_and_slide()
		else :
			lerp(head.position.y, 0.0, 0.1)
