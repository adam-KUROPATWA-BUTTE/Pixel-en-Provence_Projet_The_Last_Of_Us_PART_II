extends Node

@onready var parent : CharacterBody3D = get_parent()
@onready var head : Node3D = parent.get_node("head")
var pitch: float = 0.0

var cam_bas_pos : float
var cam_time : float = 0.0
var cam_amplitude : float = 0.03
var cam_freq : float = 4.0

func _ready() -> void:
	cam_bas_pos = head.position.y
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if parent.toglable:
		if event is InputEventMouseMotion:
			parent.rotate_y(-event.relative.x * parent.mouse_sensitivity)
			pitch = clamp(pitch - event.relative.y * parent.mouse_sensitivity, deg_to_rad(-89), deg_to_rad(89))
			head.rotation.x = pitch
		if event.is_action_pressed("Interact"):
			parent._try_interact()

func _physics_process(delta: float) -> void:
	if parent.toglable:
		var direction = Vector3.ZERO
		var forward = -parent.transform.basis.z
		var right = parent.transform.basis.x
		
		if Input.is_action_pressed('Forward'):
			direction += forward
		elif Input.is_action_pressed("Backward"):
			direction -= forward
		if Input.is_action_pressed("Right"):
			direction += right
		elif  Input.is_action_pressed("Left"):
			direction -= right
		
		if direction != Vector3.ZERO :
			cam_time += cam_freq * delta
			head.position.y = cam_bas_pos + (sin(cam_time) * cam_amplitude)
			direction = direction.normalized()
			if (Input.is_action_pressed("Run")):
				parent.velocity = direction * (parent.speed*1.5)
				cam_time += 0.08
			else:
				parent.velocity.x = direction.x * parent.speed
				parent.velocity.z = direction.z * parent.speed
			
			parent.move_and_slide()
		else :
			lerp(head.position.y, 0.0, 0.1)
