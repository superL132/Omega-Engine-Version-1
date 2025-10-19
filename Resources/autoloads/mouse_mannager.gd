extends Node

var mouse_resource = preload("res://Resources/Editor-Engine/Cursor/default mouse.tres")

func _ready():
	
	ProjectSettings.set_setting("display/mouse_cursor/custom_image", mouse_resource.default.load_path)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _set_cursor(cursor_name : String):
	
	if not cursor_name == "HIDE":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.set_custom_mouse_cursor(mouse_resource._grab_mouse_texture(cursor_name))
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
