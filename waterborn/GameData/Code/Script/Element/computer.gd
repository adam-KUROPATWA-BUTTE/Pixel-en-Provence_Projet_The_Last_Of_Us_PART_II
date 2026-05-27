extends StaticBody3D

var is_open: bool = false
var interact_delay : float = 0.0

func _ready() -> void:
	$CanvasLayer/Desktop.hide()

func interact():
	if interact_delay >= global_variable.computer_interact_delay:
		is_open = true
		$CanvasLayer/Desktop.show()
		$CanvasLayer/Desktop.load_window(3, "window")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var player = get_tree().get_first_node_in_group("player")
		player.toggled = false
		global_variable.int_label = false

func _process(delta: float) -> void:
	if is_open and Input.is_action_just_pressed("Retour"):
		is_open = false
		$CanvasLayer/Desktop.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		var player = get_tree().get_first_node_in_group("player")
		player.toggled = true
		interact_delay = 0.0
		await get_tree().create_timer(global_variable.computer_interact_delay).timeout
		global_variable.int_label = true
	interact_delay += delta
