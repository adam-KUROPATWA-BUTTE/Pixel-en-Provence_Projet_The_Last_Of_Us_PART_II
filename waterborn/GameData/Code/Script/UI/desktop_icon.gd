extends Control



@export var icon_name : String = "Default"
@export var icon_type : global_enums.icon_types = global_enums.icon_types.FOLDER
@export var window_id : int = -1
@export var window_type : global_enums.window_types

@onready var label : Label = $IconTexture/IconName
@onready var texture : TextureRect = $IconTexture
@onready var desktop : Control = get_tree().get_first_node_in_group("desktop")

var icon_textures : Array = [
	"res://GameData/Asset/Graphism/Texture/UI/folder_icon.png",
	"res://GameData/Asset/Graphism/Texture/UI/file_icon.png"
]

func _ready() -> void:
	label.text = icon_name
	texture.texture = load(icon_textures[icon_type])

func _on_icon_hit_box_pressed() -> void:
	desktop.load_window(window_id, window_type)
