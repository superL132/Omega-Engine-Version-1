extends Node2D

@onready var camera = $Camera2D
@onready var weekDesc = $"Camera2D/Control2/Week Desc"
@onready var weekArt = $Camera2D/Control2/TextureRect
@onready var dificultyNode = $Camera2D/Control2/Difficulty

var file
var folder_dir = "res://weeks/"

var weekList : Array = []
var dificultySetup : Array

var menu_option = 1
var total_options
var can_control = true
var current_difficulty = 1

var preloadDificultyTexture_easy = preload("res://Resources/Texture/Menus/Story Menu/Dificulty/easy.png")
var preloadDificultyTexture_normal = preload("res://Resources/Texture/Menus/Story Menu/Dificulty/normal.png")
var preloadDificultyTexture_hard = preload("res://Resources/Texture/Menus/Story Menu/Dificulty/hard.png")

var preloadDificultyUiTexture_idleL = preload("res://Resources/Texture/Menus/Story Menu/Dificulty/ui/idleL.png")
var preloadDificultyUiTexture_pressedL = preload("res://Resources/Texture/Menus/Story Menu/Dificulty/ui/pressedL.png")
var preloadDificultyUiTexture_idleR = preload("res://Resources/Texture/Menus/Story Menu/Dificulty/ui/idleR.png")
var preloadDificultyUiTexture_pressedR = preload("res://Resources/Texture/Menus/Story Menu/Dificulty/ui/pressedR.png")


func _ready():
	
	_load_week_files()
	dificultySetup = [[0, preloadDificultyTexture_easy], [1, preloadDificultyTexture_normal], [2, preloadDificultyTexture_hard]]
	$Camera2D/anim.play_backwards("selected")
	#$freakyMenu.play(MenuMannager.menu_music_time)
	$weekList.make_list()

func _load_week_files():
	
	weekList = JSON.parse_string(FileAccess.open("res://weeks/WeekList.json", FileAccess.READ).get_as_text())
	total_options = weekList.size()
	
	for i in weekList.size():
		weekList[i] = weekList[i].get_basename()
	
	print(weekList)

func _process(delta):
	
	file = load(folder_dir + weekList[menu_option - 1] + ".tres")
	#print(folder_dir + weekList[menu_option - 1] + ".tres")
	if can_control:
		_update_options()
	_update_other(delta)
	_update_camera(delta)

func _update_camera(delta):
	
	camera.position.y = lerpf(camera.position.y, (menu_option - 1) * 150, delta * 5)

func _update_other(delta):
	
	var texture = ImageTexture.new()
	#file = FileAccess.open(folder_dir + weekList[menu_option - 1], FileAccess.READ)
	
	
	if file.week_image == null:
		texture = load("res://icon.svg")
	else:
		texture = file.week_image
	
	var tracks_text : String
	
	for i in file.tracks.size():
		if i == 0:
			tracks_text = file.tracks[i]
		else:
			tracks_text = tracks_text + "\n" + file.tracks[i]
	
	$Camera2D/tracks/tracks.text = tracks_text
	
	dificultyNode.texture = dificultySetup[current_difficulty][1]
	
	dificultyNode.position.y = lerpf(dificultyNode.position.y, 530, delta * 10)
	weekArt.position.y = lerpf(weekArt.position.y, 49.0, delta * 10)
	weekArt.texture = texture
	weekDesc.text = file.week_desc

func _update_options():
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		$"Camera2D/Control2/Week Desc/AnimationPlayer".play("RESET")
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
		$"Camera2D/Control2/Week Desc/AnimationPlayer".play("progress text")
		weekArt.position.y = 1152
	
	if Input.is_action_just_pressed("uiLeft") or Input.is_action_just_pressed("uiRight"):
		current_difficulty += Input.get_axis("uiLeft", "uiRight")
		dificultyNode.position.y = 560
	
	if Input.is_action_just_pressed("uiBack"):
		can_control = false
		$Camera2D/anim.play("selected")
		$BackSceneTimer.start()
		$cancelMenu.play()
	
	if current_difficulty < 0:
		current_difficulty = file.dificulties.size() - 1
	if current_difficulty > file.dificulties.size() - 1:
		current_difficulty = 0
	
	if menu_option < 1:
		menu_option = total_options
	if menu_option > total_options:
		menu_option = 1
	
	_update_dificulty()

func _update_dificulty():
	
	if Input.is_action_just_pressed("uiLeft"):
		$Camera2D/Control2/Node2D/IdleL/AnimationPlayer.play("press")
		$Camera2D/Control2/Node2D/IdleL.texture = preloadDificultyUiTexture_pressedL
	elif Input.is_action_just_released("uiLeft"):
		$Camera2D/Control2/Node2D/IdleL/AnimationPlayer.play("RESET")
		$Camera2D/Control2/Node2D/IdleL.texture = preloadDificultyUiTexture_idleL
	
	if Input.is_action_just_pressed("uiRight"):
		$Camera2D/Control2/Node2D/IdleR/AnimationPlayer.play("press")
		$Camera2D/Control2/Node2D/IdleR.texture = preloadDificultyUiTexture_pressedR
	elif Input.is_action_just_released("uiRight"):
		$Camera2D/Control2/Node2D/IdleR/AnimationPlayer.play("RESET")
		$Camera2D/Control2/Node2D/IdleR.texture = preloadDificultyUiTexture_idleR

func _on_back_scene_timer_timeout():
	MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
	get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")
