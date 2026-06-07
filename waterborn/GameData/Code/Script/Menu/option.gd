extends Control

@export var menu: VBoxContainer
@export var Video_button: Button
@export var Video_setting: VBoxContainer
@export var Audio_button: Button
@export var Audio_setting: VBoxContainer
@export var Back_button: Button

var nav_stack: Array[Control] = []
var current_panel

func _ready() -> void:
	current_panel = menu
	_show_panel(menu)
	_update_back_button()
	
	Back_button.pressed.connect(_on_back_pressed)
	Video_button.pressed.connect(_navigate_to.bind(Video_setting))
	Audio_button.pressed.connect(_navigate_to.bind(Audio_setting))

func _show_panel(panel: Control):
	panel.visible = true
	
func _update_back_button():
	Back_button.visible = nav_stack.size() > 0

func _navigate_to(panel: Control):
	if current_panel:
		nav_stack.append(current_panel)
		current_panel.visible = false
	
	current_panel = panel
	_show_panel(current_panel)
	_update_back_button()
	
func _on_back_pressed():
	if nav_stack.is_empty():
		return
	
	current_panel.visible = false
	current_panel = nav_stack.pop_back()
	_show_panel(current_panel)
	_update_back_button()
