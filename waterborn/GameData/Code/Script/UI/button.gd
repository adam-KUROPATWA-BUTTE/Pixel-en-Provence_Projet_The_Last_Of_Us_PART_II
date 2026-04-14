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
			else:
				window.size = window.window_size
		"CloseButton":
			print("Bye")
			window.queue_free()
