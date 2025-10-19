extends Node2D

@onready var camera = $Camera2D

@export var descriptions_sections : PackedStringArray = ["Change yo normal settings", "idk why i put this here..."]
@export var descriptions_options : Dictionary = {"general" : ["just a test...", "Switch to full screen", "Toggles shaders, disabling this could conserve energy"]}

var data = GameData.new()

var menu_option = 1
var total_options = 2
var total_section_options : Dictionary = {"general" : 3}
var option_names : Dictionary = {"general" : ["test", "shaders", "shaders"]}
var option_section = "main"

var preferences : Dictionary = {
	"test" : false,
	"fullscreen" : false,
	"shaders" : true
}
var preferences_dir = "user://data/config.cfg"

var mainMenu_scene = preload("res://Menus/New menus/Main Menu/new_main_menu.tscn")
var optionSection_genaral = preload("res://Menus/Options/Options sections/General/general.tscn")

var last_window_setting = DisplayServer.window_get_mode()

func _ready():
	optionSection_genaral = preload("res://Menus/Options/Options sections/General/general.tscn")
	#Settings._load_data(Settings.SAVE_DIR + Settings.SAVE_FILE_NAME)
	
	descriptions_sections.resize(total_options)
	
	$Parallax2D/Sprite2D.self_modulate = Color("f56cff")
	
	$Camera2D/AnimationPlayer.play_backwards("selected")
	
	#$freakyMenu.play(MenuMannager.menu_music_time)
	if Settings._get_preferences() == null:
		Settings._save_preferences()
	else:
		Settings._update_settings()
	
	if Settings.option_section == "General":
		menu_option = 1
	if Settings.option_section == "Other":
		menu_option = 2

func _process(delta):
	
	_update_camera(delta)
	_update_section_desc()
	_update_words()
	_update_options()
	
	if option_section == "main":
		$Parallax2D/Sprite2D.self_modulate = lerp($Parallax2D/Sprite2D.self_modulate, Color("f56cff"), delta)
	else:
		$Parallax2D/Sprite2D.self_modulate = lerp($Parallax2D/Sprite2D.self_modulate, Color("1c3272"), delta)
	
	

func _update_options():
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
	
	if menu_option < 1:
		menu_option = 2
	if menu_option > 2:
		menu_option = 1
	
	if Input.is_action_just_pressed("uiConfirm"):
		if menu_option == 1:
			Settings.option_section = "General"
		if menu_option == 2:
			Settings.option_section = "Other"
		
		MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
		get_tree().change_scene_to_file("res://Menus/Options/Options sections/General/general.tscn")
	
	if Input.is_action_just_pressed("uiBack"):
		$cancelMenu.play()
		$Camera2D/AnimationPlayer.play("selected")
		$changeSceneBackTimer.start()

func _update_camera(delta):
	
	if option_section == "main":
		camera.position.x = lerp(camera.position.x, float(0), delta * 3)
		camera.position.y = lerp(camera.position.y, float(menu_option - 1) * 50, delta * 3)
	else:
		camera.position.x = lerp(camera.position.x, float($sections.position.x), delta * 3)
		camera.position.y = lerp(camera.position.y, float(menu_option - 1) * 150, delta * 3)
	
	
	

func _update_words():
	if menu_option == 1:
		$General.text = ">GENERAL<"
	else:
		$General.text = "GENERAL"
	
	if menu_option == 2:
		$Other.text = ">OTHER<"
	else:
		$Other.text = "OTHER"

func _update_section_desc():
	
	if option_section == "main":
		var desc = descriptions_sections[menu_option - 1]
		$Camera2D/desc.text = desc
	else:
		var desc_array : Array = descriptions_options.get(option_section)
		var desc = desc_array[menu_option - 1]
		$Camera2D/desc.text = desc


func _on_change_scene_back_timer_timeout():
	MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
	Settings.option_section = "General"
	get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")
