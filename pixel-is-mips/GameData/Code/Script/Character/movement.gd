extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.003
@export var gravity: float = 9.8

var head: Node3D
var pitch: float = 0.0

func _ready() -> void:
	head = $head
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-89), deg_to_rad(89))
		head.rotation.x = pitch

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	var forward = -transform.basis.z
	var right = transform.basis.x
	
	if Input.is_action_pressed("move_forward"):
		direction += forward
	elif Input.is_action_pressed("move_back"):
		direction -= forward
	elif Input.is_action_pressed("right"):
		direction += right
	elif  Input.is_action_pressed("left"):
		direction -= right
		
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta	

	move_and_slide()
