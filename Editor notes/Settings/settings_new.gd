extends Node


var preferences : Dictionary = {
	"test" : false,
	"test2" : true,
	"shaders" : true,
	"3d" : true,
	"updates" : true,
	"vsync" : true,
	"downScroll" : false
}

var option_section = "General"

var removed_options : Array
var new_options : Array

var defaultSettings : Dictionary
var preferences_folder_dir = "user://data"
var preferences_dir = "user://data/config.cfg"

var config = ConfigFile.new()

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
		FileAccess.open(preferences_dir, FileAccess.WRITE_READ)
		_set_config()
		config.save(preferences_dir)
	#if JSON.parse_string(FileAccess.open(preferences_dir, FileAccess.READ).get_as_text()) == null:
		#FileAccess.open(preferences_dir, FileAccess.WRITE_READ).store_string(JSON.stringify(preferences))
	#_fix_file()
	
	if FileAccess.open(preferences_dir, FileAccess.READ).get_as_text().is_empty():
		FileAccess.open(preferences_dir, FileAccess.WRITE_READ)
		_set_config()
		config.save(preferences_dir)

func _update_settings():
	
	preferences = _get_preferences()

func _save_preferences():
	var saveFile = FileAccess.open(preferences_dir, FileAccess.READ_WRITE)
	
	_set_config()
	
	config.save(preferences_dir)
	#saveFile.store_string(config.to_string())
	
	print("The info : ", Settings.preferences, " was stored")
	print("Save successful")
	
	saveFile.close()

func _set_config():
	
	var pref_keys = preferences.keys()
	
	print(pref_keys)
	
	for i in pref_keys.size():
		config.set_value("Preferences", pref_keys[i], preferences.get(pref_keys[i]))
	print(config)

func _get_config():
	#broken
	
	var config_as_json : Dictionary
	var config_keys = config.get_section_keys("Preferences")
	
	print(str("Config Keys : ", config_keys))
	
	for i in config_keys.size():
		config_as_json.set(config_keys[i], config.get_value("Preferences", config_keys[i]))
	
	print(config_as_json)
	return config_as_json

func _get_preferences():
	var saveFile = FileAccess.open(preferences_dir, FileAccess.READ)
	
	if saveFile == null:
		return null
	else:
		return _get_config()
	
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
	print("Settings has been reset")
