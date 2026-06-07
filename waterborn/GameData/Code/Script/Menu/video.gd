extends VBoxContainer

@export var resolution_option: OptionButton
@export var Fullscreen_check: CheckBox
@export var Borderless_check: CheckBox
@export var VSync_check: CheckBox

func _ready() -> void:
	var resolution =  [
		Vector2i(1920, 1080),
		Vector2i(1600, 900),
		Vector2i(1280, 720)
	]
	for res in resolution:
		resolution_option.add_item("%dx%d" % [res.x, res.y])
	
	load_current_setting()
	
	resolution_option.item_selected.connect(_on_resolution_selected)
	Fullscreen_check.toggled.connect(on_fullscreen_toggle)
	Borderless_check.toggled.connect(on_bordoless_toggle)
	VSync_check.toggled.connect(on_vsync_toggled)
		
func load_current_setting():
	var mode = DisplayServer.window_get_mode()
	Fullscreen_check.button_pressed = mode == DisplayServer.WINDOW_MODE_FULLSCREEN
	Borderless_check.button_pressed = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	VSync_check.button_pressed = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	
	var window_size = DisplayServer.window_get_size()
	for i in range(resolution_option.item_count):
		var res_text = resolution_option.get_item_text(i)
		var parts = res_text.split("x")
		if parts.size() == 2 and int (parts[0]) == window_size.x and int(parts[1]) == window_size.y :
			resolution_option.select(i)
			break
		
func _on_resolution_selected(index: int):
	var text = resolution_option.get_item_text(index)
	var parts = text.split("x")
	if parts.size() == 2:
		DisplayServer.window_set_size(Vector2i(int(parts[0]), int(parts[1])))
		
func on_fullscreen_toggle(enabled: bool):
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Borderless_check.set_pressed_no_signal(false)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func on_bordoless_toggle(enabled: bool):
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		Borderless_check.set_pressed_no_signal(false)
		return
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, enabled)


func on_vsync_toggled(enabled: bool):
	var mode = DisplayServer.VSYNC_ENABLED if enabled else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(mode)
	
