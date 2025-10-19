extends Node

var previous_options
var current_options

func _ready():
	_set_options()

func _process(delta):
	
	current_options = Settings.preferences
	
	if not previous_options == current_options:
		_set_options()
		previous_options = current_options

func _set_options():
	if Settings.preferences.vsync == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	if Settings.preferences.vsync == false:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
