extends Resource

class_name CursorAssets

@export_group("Cursor Textures")
#cursor texture
@export var default : Texture
@export var cell : Texture
@export var cross : Texture
@export var crossHair : Texture
@export var default_new : Texture
@export var eraser : Texture
@export var grabbing : Texture
@export var pointer : Texture
@export var hourGlass : Texture
@export var scroll : Texture
@export var textVertical : Texture
@export var text : Texture
@export var zoomIn : Texture
@export var zoomOut : Texture


func _grab_mouse_texture(name):
	
	if typeof(name) == 2:
		if name == 1:
			return default
		if name == 2:
			return cell
		if name == 3:
			return cross
		if name == 4:
			return crossHair
		if name == 5:
			return default_new
		if name == 6:
			return eraser
		if name == 7:
			return grabbing
		if name == 8:
			return pointer
		if name == 9:
			return hourGlass
		if name == 10:
			return scroll
		if name == 11:
			return textVertical
		if name == 12:
			return text
		if name == 13:
			return zoomIn
		if name == 14:
			return zoomOut
	
	elif typeof(name) == 4:
		if name == "default":
			return default
		if name == "cell":
			return cell
		if name == "cross":
			return cross
		if name == "crossHair":
			return crossHair
		if name == "default_new":
			return default_new
		if name == "eraser":
			return eraser
		if name == "grabbing":
			return grabbing
		if name == "pointer":
			return pointer
		if name == "hourGlass":
			return hourGlass
		if name == "scroll":
			return scroll
		if name == "textVertical":
			return textVertical
		if name == "text":
			return text
		if name == "zoomIn":
			return zoomIn
		if name == "zoomOut":
			return zoomOut
