extends Node


var preferences : Dictionary = {
	"test" : false,
	"test2" : true,
	"shaders" : true,
	"3d" : true,
	"updates" : true,
	"vsync" : true
}

var option_section = "General"

var removed_options : Array
var new_options : Array

var defaultSettings : Dictionary
var preferences_folder_dir = "user://data"
var preferences_dir = "user://data/config.cfg"

func _ready():
	
	defaultSettings = preferences
	
	_check_nessesary()
	
	print(_get_preferences())
	
	if _get_preferences() == null:
		printerr("The options file returned null, attempting to fix the error")
		_save_preferences()
	else:
		_update_settings()

func _check_nessesary():
	if not FileAccess.file_exists(preferences_dir):
		DirAccess.make_dir_recursive_absolute(preferences_folder_dir)
		FileAccess.open(preferences_dir, FileAccess.WRITE_READ)
		print("creating new file")
		_save_preferences()
	if not FileAccess.open(preferences_dir, FileAccess.READ_WRITE).get_as_text():
		print("File is null")
		FileAccess.open(preferences_dir, FileAccess.WRITE_READ).store_string(JSON.stringify(preferences))
	if JSON.parse_string(FileAccess.open(preferences_dir, FileAccess.READ).get_as_text()) == null:
		FileAccess.open(preferences_dir, FileAccess.WRITE_READ).store_string(JSON.stringify(preferences))
	
	#_fix_file()

func _update_settings():
	
	preferences = _get_preferences()

func _save_preferences():
	var saveFile = FileAccess.open(preferences_dir, FileAccess.READ_WRITE)
	
	saveFile.store_string(JSON.stringify(Settings.preferences, "\t"))
	
	print("The info : ", Settings.preferences, " was stored")
	print("Save successful")
	
	saveFile.close()

func _get_preferences():
	var saveFile = FileAccess.open(preferences_dir, FileAccess.READ)
	
	if saveFile == null:
		return null
	else:
		return JSON.parse_string(saveFile.get_as_text())
	
	saveFile.close()

func _fix_file_placeholder():
	var file : Dictionary = _get_preferences()
	if not preferences.keys() == file.keys():
		var fix_file = FileAccess.open(preferences_dir, FileAccess.WRITE_READ)
		fix_file.store_string(JSON.stringify(preferences))
		fix_file.close()

func _fix_file():
	_get_old_and_new_options()
	

func _get_old_and_new_options():
	
	var json = JSON.parse_string(FileAccess.open(preferences_dir, FileAccess.WRITE_READ).get_as_text())
	var json_keys
	var preferences_keys
	
	var keys_that_dont_exist : Array
	
	# Check for old options
	print(json)
	json_keys = json.keys()
	preferences_keys = preferences.keys()
	
	for i in json.size():
		if not json_keys.has(preferences_keys[i]):
			keys_that_dont_exist.append(preferences.get(preferences_keys[i]))
		
	print("Keys that don't exist: ", keys_that_dont_exist)

func _reset():
	
	preferences = defaultSettings
	_save_preferences()
	print("Settings has been reset")
