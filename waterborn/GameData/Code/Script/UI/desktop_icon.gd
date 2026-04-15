extends Control

enum icon_types {FOLDER, FILE}

@export var icon_name : String = "Default"
@export var icon_type : icon_types = icon_types.FOLDER
@export var window_id : int = -1

@onready var label : Label = $IconTexture/IconName
@onready var texture : TextureRect = $IconTexture
@onready var desktop : Control = $"../.."

var icon_textures : Array = [
	"res://GameData/Asset/Graphism/Texture/UI/folder_icon.png",
	"res://GameData/Asset/Graphism/Texture/UI/file_icon.png"
]

func _ready() -> void:
	label.text = icon_name
	texture.texture = load(icon_textures[icon_type])

func _on_icon_hit_box_pressed() -> void:
	desktop.load_window(window_id, "window")
