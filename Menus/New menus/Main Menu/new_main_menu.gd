extends Node2D

@onready var camera = $Camera2D
@onready var camera3d = $"SubViewport/3d words/camera base"
@onready var visual = $Camera2D/Visual #visual is the graphic in front the bg

var visualTexture_storymode = preload("res://Resources/Texture/Menus/Main Menu/Images/storymode.png")
var visualTexture_freeplay = preload("res://Resources/Texture/Menus/Main Menu/Images/freeplay.png")
var visualTexture_options = preload("res://Resources/Texture/Menus/Main Menu/Images/options.png")
var visualTexture_credits = preload("res://Resources/Texture/Menus/Main Menu/Images/credits.png")
var visualTexture_missing = preload("res://icon.svg")

@export var section_descriptions : Array = ["Quit waiting and get funkey!!!", "Pick a song, any song!", "Check your options, dont be frightened!", "Check out the lovely people that contributed to this mod :>", "In game accomplishments! Give yourself a pat on the back!!!"]

var menu_option = 1
var total_options = 5
var can_control = true
var current_action = "startup"

var visualFlashStat = 1

var menuMusic_pitch = 1
func _ready():
	
	
	if !MenuMannager.startup:
		pass
	
	if not MenuMannager.menu_music_player.playing:
		MenuMannager._freeplay_request(false)
	
	if MenuMannager.coming_from_extra_menu:
		$Camera2D/Anim.play_backwards("extras menu")
		MenuMannager.coming_from_extra_menu = false
	else:
		$Camera2D/Anim.play_backwards("selected")
	$"SubViewport/3d words/AnimationPlayer".play_backwards("selelcted")
	
	MenuMannager.startup = false
	menu_option = MenuMannager.last_main_option
	camera.position.x = MenuMannager.last_main_option * 200
	
	camera3d.position.y = MenuMannager.last_main_option - 0 * -2
	
	
	
	#$freakyMenu.play(MenuMannager.menu_music_time)
	
	var version_data = FileAccess.open("res://Data/version info.json", FileAccess.READ)
	var json_versionData = JSON.new()
	json_versionData = json_versionData.parse_string(FileAccess.get_file_as_string("res://Data/version info.json"))
	
	$Camera2D/version.text = str("[This mod is no longer in development]", json_versionData.get("versionType"), " ", (ProjectSettings.get_setting("omega/version")))

func _process(delta):
	
	
	
	camera.position.y = lerp(camera.position.y, float(menu_option - 1) * 200, delta * 3)
	camera.position.x = lerp(camera.position.x, float(menu_option - 1) * 75, delta * 3)
	
	camera3d.position.y = lerpf(camera3d.position.y, 0 - (menu_option - 1) * 2, delta * 3)
	camera3d.position.x = lerpf(camera3d.position.x, (menu_option - 1) * 2, delta * 3)
	
	visual.position.y = lerpf(visual.position.y, 0, delta * 10)
	
	if can_control:
		_update_option()
	_update_words(delta)
	#_update_words_old()
	_update_visual_image()
	_update_other()
	
	

func _update_other():
	
	$Camera2D/Desc.text = section_descriptions[menu_option - 1]

func _update_visual_image():
	if menu_option == 1:
		visual.texture = visualTexture_storymode
	elif menu_option == 2:
		visual.texture = visualTexture_freeplay
	elif menu_option == 3:
		visual.texture = visualTexture_options
	elif menu_option == 4:
		visual.texture = visualTexture_credits
	else:
		visual.texture = visualTexture_missing

func _update_option():
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
		visual.position.y = 50
		$Camera2D/Desc/AnimationPlayer.play("RESET")
		$Camera2D/Desc/AnimationPlayer.play("update")
		
		if menu_option < 1:
			menu_option = total_options
	
		if menu_option > total_options:
			menu_option = 1
	
	if Input.is_action_just_pressed("uiBack"):
		
		
		$"change scene".start()
		can_control = false
		$cancelMenu.play()
		$Camera2D/Anim.play("selected")
		$"SubViewport/3d words/AnimationPlayer".play("selelcted")
		current_action = "back"
	
	if Input.is_action_just_pressed("uiConfirm"):
		if not menu_option == 5:
			$"change scene".start()
			can_control = false
			$confirmMenu.play()
			$Camera2D/Anim.play("selected")
			$"SubViewport/3d words/AnimationPlayer".play("selelcted")
			$Camera2D/Visual/AnimationPlayer.play("flash")
			current_action = "selecting"
			if menu_option == 2:
				MenuMannager._freeplay_request(true)
				$freakyMenu/AnimationPlayer.play("freeplay fade")
		else:
			$Camera2D/alert/AnimationPlayer.play("animate")
	
	if Input.is_action_just_pressed("debug1"):
		$"change scene".start()
		can_control = false
		$confirmMenu.play()
		$Camera2D/Anim.play("extras menu")
		$"SubViewport/3d words/AnimationPlayer".play("selelcted")
		$Camera2D/Visual/AnimationPlayer.play("flash")
		current_action = "go to extra menu"

func _update_words(delta):
	
	var story = $"SubViewport/3d words/story"
	var freeplay = $"SubViewport/3d words/freeplay"
	var options = $"SubViewport/3d words/options"
	var credits = $"SubViewport/3d words/credits"
	var awards = $"SubViewport/3d words/awards"
	
	if menu_option == 1:
		story.play("selected")
	else:
		story.play("basic")
	
	if menu_option == 2:
		freeplay.play("selected")
	else:
		freeplay.play("basic")
	
	if menu_option == 3:
		options.play("selected")
	else:
		options.play("basic")
	
	if menu_option == 4:
		credits.play("selected")
	else:
		credits.play("basic")
	
	if menu_option == 5:
		awards.play("selected")
	else:
		awards.play("basic")
	

func _update_words_old():
	if menu_option == 1:
		$"words/Story Mode".play("selected")
	else:
		$"words/Story Mode".play("basic")
	
	if menu_option == 2:
		$"words/Free Play".play("selected")
	else:
		$"words/Free Play".play("basic")
	
	if menu_option == 3:
		$"words/Options".play("selected")
	else:
		$"words/Options".play("basic")
	
	if menu_option == 4:
		$"words/Credits".play("selected")
	else:
		$"words/Credits".play("basic")





func _on_anim_animation_finished(anim_name):
	
	if current_action == "selecting":
		MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
		MenuMannager.last_main_option = menu_option
		
		
		if menu_option == 1:
			
			
			get_tree().change_scene_to_file("res://Menus/New menus/Story/story_mode.tscn")
			
		if menu_option == 2:
			
			
			get_tree().change_scene_to_file("res://Menus/New menus/Freeplay/freeplay.tscn")
			
		
		if menu_option == 3:
			
			get_tree().change_scene_to_file("res://Menus/Options/options.tscn")
		
		if menu_option == 4:
			
			get_tree().change_scene_to_file("res://Menus/New menus/Credits(new)/credits.tscn")
		
		
	elif current_action == "back":
		MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
		MenuMannager.last_main_option = 1
		
		get_tree().change_scene_to_file("res://Menus/New menus/Press Start/press_start.tscn")
	
	elif current_action == "go to extra menu":
		MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
		MenuMannager.last_main_option = 1
		
		get_tree().change_scene_to_file("res://Menus/Extras Menu/extras_menu.tscn")


func _on_timer_timeout():
	if visualFlashStat == 1:
		visualFlashStat = 2
	
	if visualFlashStat == 2:
		visualFlashStat = 1
	
