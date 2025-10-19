extends Label

@onready var root = $"../../.."
@onready var checkBox = $Sprite2D

var id = 0
var optionFile_name = ""

var last_value

#var preloadTexture_checkbox_true = preload("res://Resources/Texture/Menus/Options/Check box/checkbox-true.png")
#var preloadTexture_checkbox_false = preload("res://Resources/Texture/Menus/Options/Check box/checkbox-false.png")

func _process(delta):
	
	_id_operations()
	if typeof(Settings.preferences.get(optionFile_name)) == 1:
		_update_checkboxes()
	

func _id_operations():
	
	if root.menu_option == id:
		modulate = Color("FFFFFF")
	else:
		modulate = Color("555555")

func _update_checkboxes():
	
	
	
	if not last_value == Settings.preferences.get(optionFile_name):
		var cur_value = Settings.preferences.get(optionFile_name)
		if cur_value:
			checkBox.play("checkbox anim")
			print("1")
		else:
			checkBox.play("checkbox anim reverse")
			print("0")
	
	last_value = Settings.preferences.get(optionFile_name)


func _on_sprite_2d_animation_finished():
	if $Sprite2D.animation == "checkbox anim reverse":
		$Sprite2D.play("checkbox")
