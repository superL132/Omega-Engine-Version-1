extends Node
var folder_dir = "user://data/"



func _write_file(file_dir, data):
	
	var path = folder_dir + file_dir
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	#if FileAccess.file_exists(path):
	
	var json_as_String = JSON.stringify(data, "/t")
	
	file.store_string(json_as_String)
	
	file.close()
	#else:
	printerr("Error with opening and writing file")
