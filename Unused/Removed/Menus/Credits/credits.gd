extends Node2D

@export var credit_desc : PackedStringArray = ["The director, artist, programmer and animator for this mod. I also created this engine :> (I need a raise...)", "The creator of Koen and Aster. Thank you for inspiring me :D", "The creator of the Koen and Aster song", "The creator of the songs : 'Boggle' and 'Blurt'. I love your songs btw :D", "Engine programming support", "Assistant artist", "Engine provider (the engine for the engine), thanks godot devs :)!!", "Playtester 1 : Rosa, This person is extremely lively and bubly. Thanks for contributing :)", "Playtester 2 : Kitsune, This person is extremely menicing and friendly. Thanks again to all of the playtesters :D"]
@export var credit_color : PackedColorArray = ["DBBE00", "4888C5", "17003D", "B8900D", "FF0000", "23FF86", "478CBF", Color.DARK_CYAN, Color.DIM_GRAY]
@export var credit_websites : PackedStringArray = ["https://linktr.ee/superl132","https://www.youtube.com/@mastertrapmon1588/featured", "https://www.youtube.com/@StarVerseVictory", "https://www.megamangoband.com", "https://scratch.mit.edu/users/ScratchScientist9100/", "https://www.deviantart.com/enchantedchoco", "https://godotengine.org"]

@onready var camera = $Camera2D
@onready var bg = $Camera2D/MenuDesat

var menu_option = 1
var total_options = 9
var can_control = true


func _ready():
	credit_desc.resize(total_options)
	credit_color.resize(total_options)
	credit_websites.resize(total_options + 1)
	$freakyMenu.play(MenuMannager.menu_music_time)
	$Camera2D/AnimationPlayer.play_backwards("select")
	$Camera2D/MenuDesat.self_modulate = credit_color[0]

func _process(delta):
	
	if can_control:
		_update_options()
	
	_update_other(delta)
	
	bg.self_modulate = _bg_color_change(bg.self_modulate, credit_color[menu_option - 1], delta)
	$Camera2D/Panel/Label.text = credit_desc[menu_option - 1]
	
	if !credit_websites[menu_option - 1] == "" or null:
		$Camera2D/Panel2/Label.text = credit_websites[menu_option - 1]
	else:
		$Camera2D/Panel2/Label.text = "No Link Provided"
	
	
	if menu_option > 0 and menu_option < 5:
		camera.position.y = lerpf(camera.position.y, (menu_option - 1) * 150, delta * 3)
	else:
		camera.position.y = lerpf(camera.position.y, (menu_option - 1) * 150 + 150, delta * 3)

func _update_other(delta):
	var title_Main_Crew = $"Credit Names/Main crew"
	var title_Contributors = $"Credit Names/Contributors"
	if menu_option > 1 and menu_option < 5:
		title_Main_Crew.position.y = lerpf(title_Main_Crew.position.y, ((menu_option - 1) * 150) - 250, delta * 3)
		title_Main_Crew.position.x = lerpf(title_Main_Crew.position.x, -950, delta * 3)
		title_Main_Crew.self_modulate = lerp(title_Main_Crew.self_modulate, Color("ffffff50"), delta)
	else:
		title_Main_Crew.position = lerp(title_Main_Crew.position, Vector2(-580, -198), delta * 3)
		title_Main_Crew.self_modulate = lerp(title_Main_Crew.self_modulate, Color("ffffff"), delta)
	
	if menu_option > 5 and menu_option < 10:
		title_Contributors.position.y = lerpf(title_Contributors.position.y, ((menu_option - 1) * 150) - 250 + 150, delta * 3)
		title_Contributors.position.x = lerpf(title_Contributors.position.x, -950, delta * 3)
		title_Contributors.self_modulate = lerp(title_Contributors.self_modulate, Color("ffffff50"), delta)
	else:
		title_Contributors.position = lerp(title_Contributors.position, Vector2(-580, 603), delta * 3)
		title_Contributors.self_modulate = lerp(title_Contributors.self_modulate, Color("ffffff"), delta)

func _update_options():
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
		$Camera2D/Panel2/AnimationPlayer.play("RESET")
		$Camera2D/Panel2/AnimationPlayer.play("scroll")
	
	if Input.is_action_just_pressed("uiConfirm"):
		_select_credit()
	
	if Input.is_action_just_pressed("uiBack"):
		can_control = false
		$Camera2D/AnimationPlayer.play("select")
		$BackSceneTimer.start()
		$cancelMenu.play()
	
	if menu_option < 1:
		menu_option = total_options
	
	if menu_option > total_options:
		menu_option = 1
	

func _select_credit():
	
	OS.shell_open(credit_websites[menu_option - 1])
	#OS.shell_open()

func _bg_color_change(from : Color, to : Color, delta):
	var transition : Color = from
	var time = 0
	time += delta
	time = clampf(time, 0.0, 1.0)
	transition = lerp(transition, to, time)
	
	return transition
	


func _on_back_scene_timer_timeout():
	MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
	get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")
