extends TextureButton

@onready var window = get_parent().get_parent()

func _pressed():
	match name:
		#############################
		# COMPUTER'S WINDOW BUTTONS #
		#############################
		"ReduceButton":
			pass
		"FullscreenButton":
			if Vector2i(window.size) == window.window_size:
				window.size = get_viewport().get_visible_rect().size
				window.position = Vector2i.ZERO
			else:
				window.size = window.window_size
				window.position = window.window_pos
		"CloseButton":
			window.queue_free()
