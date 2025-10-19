extends Node2D

@onready var camera = $Camera2D

var options_general = [["Shaders", "shaders"], ["3D Engine", "3d"], ["Check for Updates", "updates"], ["V-Sync", "vsync"]]
var options_other = [["test", "test"]]

var options_info = {"test" : ["Test1, idk why I put this here"],
	"test2" : ["Test2 i here too >:D"],
	"fullscreen" : ["Switches your screen to fullscreen mode (no effect)"],
	"shaders" : ["Turns on shaders, can decrease performance, recomended for those who have video cards"],
	"3d" : ["If unchecked, disables Godot's 3D engine (no effect)"],
	"updates" : ["If unchecked, stops prompting you to update the engine"],
	"vsync" : ["Does whatever V-Sync does, idk"]
}

var options = []

var preloadScene_mainOptions = preload("res://Menus/Options/options.tscn")

var menu_option = 0
var can_control = true
func _ready():
	
	preloadScene_mainOptions = load("res://Menus/Options/options.tscn")
	
	_set_options()
	
	_make_option_labels()
	
	#$freakyMenu.play(MenuMannager.menu_music_time)
	$scrollMenu.play()
	

func _set_options():
	var section = Settings.option_section
	
	if section == "General":
		options = options_general
	if section == "Other":
		options = options_other
	
	$Camera2D/Label.text = Settings.option_section

func _process(delta):
	
	if can_control:
		_camera(delta)
	_update_other()

func _camera(delta):
	
	camera.position.y = lerpf(camera.position.y, menu_option * 150, delta * 3)
	
	
	if camera.position.y < 225:
		camera.position.y = 225
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
	
	if menu_option < 0:
		menu_option = options.size() - 1
	if menu_option > options.size() - 1:
		menu_option = 0
	
	if Input.is_action_just_pressed("uiConfirm"):
		$scrollMenu.play()
		if Settings.preferences.get(options[menu_option][1]):
			Settings.preferences.set(options[menu_option][1], false)
			Settings._save_preferences()
		else:
			Settings.preferences.set(options[menu_option][1], true)
			Settings._save_preferences()
	
	if Input.is_action_just_pressed("uiBack"):
		MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
		get_tree().change_scene_to_file("res://Menus/Options/options.tscn")
	
	if Input.is_key_pressed(KEY_R):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		can_control = false
		$ConfirmationDialog.show()

func _update_other():
	
	$Camera2D/Panel/Label.text = options_info.get(options[menu_option][1])[0]

func _make_option_labels():
	
	for i in options.size():
		var labelTemplate = $"Option tags/Node2D/TemplateLabel".duplicate()
		labelTemplate.position.y = i * 150
		labelTemplate.id = i
		labelTemplate.text = options[i][0]
		labelTemplate.optionFile_name = options[i][1]
		
		$"Option tags/Node2D".add_child(labelTemplate)


func _on_confirmation_dialog_canceled():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	can_control = true


func _on_confirmation_dialog_confirmed():
	Settings._reset()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	can_control = true
