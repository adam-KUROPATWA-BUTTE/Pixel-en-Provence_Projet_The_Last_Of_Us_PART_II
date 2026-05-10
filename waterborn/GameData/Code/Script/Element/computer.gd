extends StaticBody3D

var is_open: bool = false

func _ready() -> void:
	$CanvasLayer/Desktop.hide()

func interact():
	is_open = true
	$CanvasLayer/Desktop.show()
	$CanvasLayer/Desktop.load_window(3, "window")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var player = get_tree().get_first_node_in_group("player")
	player.toglable = false
	player.get_node("CanvasLayer/BoxContainer/Label").hide()

func _process(_delta: float) -> void:
	if is_open and Input.is_action_just_pressed("retour"):
		is_open = false
		$CanvasLayer/Desktop.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		var player = get_tree().get_first_node_in_group("player")
		player.toglable = true
		player.get_node("CanvasLayer/BoxContainer/Label").show()
