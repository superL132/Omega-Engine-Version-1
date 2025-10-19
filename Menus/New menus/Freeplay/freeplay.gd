extends Node2D


var song_dir = "res://Resources/Music/Songs/"
var audio

var chart_file

var folder_dir = "res://weeks/"
var chart_folder_dir = "res://Songs/"

var weekList
var week_dir_list
var songList : Array
var songColorList : Array
var songFileList : Array

var menu_option = 0
var can_control = true
var songLabel_scroll = false
var songLabel_scroll_startOver = false
var last_album
var camera_bump = false

@onready var camera = $Camera2D

func _ready():
	
	$Camera2D/anim.play_backwards("selected")
	$Node2D/AnimationPlayer.play("enter")
	_load_files()
	_make_labels()
	$AudioStreamPlayer.stream = _load_song_file(1, songList[0])
	$AudioStreamPlayer.play()
	_load_shit()
	if not chart_file == null:
		$Conductor.tempo = chart_file.bpm

func _load_files():
	
	weekList = JSON.parse_string(FileAccess.open("res://weeks/WeekList.json", FileAccess.READ).get_as_text())
	week_dir_list = JSON.parse_string(FileAccess.open("res://weeks/WeekList.json", FileAccess.READ).get_as_text())
	print(week_dir_list)
	
	for i in weekList.size():
		var week_file = folder_dir + weekList[i] + ".tres"
		var loaded_week_file = load(week_file)
		var new_songs : Array
		
		print(week_file)
		for i2 in loaded_week_file.tracks.size():
			print(loaded_week_file.tracks[i2].capitalize())
			songFileList.append(loaded_week_file.tracks[i2])
			songList.append(loaded_week_file.tracks[i2].capitalize())
			songColorList.append(loaded_week_file.song_colors[i2])
	print(songList)
	print(songColorList)

func _make_labels():
	
	var template = $Node2D/Label
	
	for i in songList.size():
		
		template.text = songList[i]
		template.position.y = (i * 150) + 324.0
		
		$Node2D.add_child(template.duplicate())

func _process(delta):
	
	_camera(delta)
	_update_label(delta)
	if can_control:
		_option()

func _update_label(delta):
	
	if songLabel_scroll:
		$Camera2D/UI/Control/Control/Label.position.x += -100 * delta
	if $Camera2D/UI/Control/Control/Label.position.x < -$Camera2D/UI/Control/Control/Label.size.x:
		$Camera2D/UI/Control/Control/Label.position.x = 345.0
		songLabel_scroll_startOver = true
	
	
	if songLabel_scroll_startOver:
		if $Camera2D/UI/Control/Control/Label.position.x < 0:
			songLabel_scroll = false
			songLabel_scroll_startOver = false
			$Camera2D/UI/Control/Control/Timer.wait_time = 0.75
			$Camera2D/UI/Control/Control/Timer.start()
	
	if not chart_file == null:
		$Camera2D/UI/Control/Control/Label3.text = str(snappedf($AudioStreamPlayer.get_playback_position(), 0.1), " / ", snappedf($AudioStreamPlayer.stream.get_length(), 0.1))

func _camera(delta):
	#var tween = create_tween()
	#
	#tween.set_trans(Tween.TRANS_BOUNCE)
	#tween.tween_property(camera, "position", Vector2(0, menu_option * 150), 1)
	
	camera.position.y = lerpf(camera.position.y, menu_option * 150, delta * 3)
	
	if camera_bump:
		camera.zoom = lerp(camera.zoom, Vector2(1, 1), delta * 3)
		if not chart_file == null:
			$Conductor.tempo = lerpf($Conductor.tempo, chart_file.bpm, delta * 3)
			$Camera2D/UI/Control/Control/Label2.text = str("BPM : ", snappedi(chart_file.bpm, 1))
	
	$"Camera2D/Back Ground/Sprite2D".modulate = lerp($"Camera2D/Back Ground/Sprite2D".modulate, songColorList[menu_option], delta)

func _option():
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$ScrollMenu.play()
		
	
	if Input.is_action_just_pressed("uiBack"):
		camera_bump = false
		can_control = false
		$AudioStreamPlayer/AnimationPlayer.play("selected")
		$Camera2D/anim.play("selected")
		$changeSceneTimer.start()
		$cancelMenu.play()
	
	if menu_option > songList.size() - 1:
		menu_option = 0
	if menu_option < 0:
		menu_option = songList.size() - 1
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		$AudioStreamPlayer.stream = _load_song_file(1, songList[menu_option])
		$AudioStreamPlayer.play()
		_load_shit()
		

func _load_song():
	audio = load(str(song_dir, "blurt", "/Inst.ogg"))

func _load_song_file(get_id : int, songName : String):
	
	#note: the file needs to be .ogg, otherwise it wont work...
	
	songName = songName.to_lower()
	var file = load(str("res://Resources/Music/Songs/", songName, "/Inst.ogg"))
	
	
	print("Loading Song : ", songName)
	print("Dir : ", "res://Resources/Music/Songs/", songName, "/Inst.ogg")
	if get_id == 1:
		return file
	if get_id == 2:
		return

func _load_shit():
	
	$Camera2D/UI/Control/Control/Timer.wait_time = 2.0
	
	if FileAccess.file_exists(str(chart_folder_dir, songList[menu_option].to_lower(), "/normal.tres")):
		$Camera2D/UI/Control/Control/Label.size.x = 0
		$Camera2D/UI/Control/Control/Label.position.x = 0
		songLabel_scroll = false
		$Camera2D/UI/Control/Control/Timer.start()
		
		print(str(chart_folder_dir, songList[menu_option].to_lower(), "/normal.tres"))
		chart_file = load(str(chart_folder_dir, songList[menu_option].to_lower(), "/normal.tres"))
		if FileAccess.file_exists("res://Resources/Texture/Menus/freeplay/album covers/" + chart_file.album + ".png"):
			print("album cover availuable")
			#Reminder to make this automatic (too lasy, lol)
			$Camera2D/UI/Control/Panel/TextureRect.texture = load("res://Resources/Texture/Menus/freeplay/album covers/" + chart_file.album + ".png")
		else:
			printerr("album cover unavailuable")
			$Camera2D/UI/Control/Panel/TextureRect.texture = load("res://icon.svg")
		$Camera2D/UI/Control/Control/Label.text = str(songList[menu_option], " by ", chart_file.artist, ", ", chart_file.album)
		
		if not last_album == chart_file.album:
			$Camera2D/UI/Control/Panel/TextureRect/AnimationPlayer.play("RESET")
			$Camera2D/UI/Control/Panel/TextureRect/AnimationPlayer.play("change album")
		
		camera_bump = true
		last_album = chart_file.album
	else:
		$Camera2D/UI/Control/Control/Label.size.x = 0
		$Camera2D/UI/Control/Control/Label.position.x = 0
		songLabel_scroll = false
		$Camera2D/UI/Control/Control/Timer.start()
		chart_file = null
		camera_bump = false
		$Camera2D/UI/Control/Panel/TextureRect.texture = load("res://icon.svg")
		$Camera2D/UI/Control/Control/Label.text = "No Chart!"
		
		if not last_album == "No Album!":
			$Camera2D/UI/Control/Panel/TextureRect/AnimationPlayer.play("RESET")
			$Camera2D/UI/Control/Panel/TextureRect/AnimationPlayer.play("change album")
		
		last_album = "No Album!"

func _on_change_scene_timer_timeout():
	MenuMannager.menu_music_time = 0
	get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")


func _on_timer_timeout():
	songLabel_scroll = true


func _on_anim_animation_finished(anim_name):
	if anim_name == "selected":
		camera_bump = true


func _on_conductor_new_beat(current_beat, measure_relative):
	if camera_bump:
		$"Camera2D/flashy crap/AnimationPlayer".play("RESET")
		$"Camera2D/flashy crap/AnimationPlayer".play("flash")
		camera.zoom = Vector2(1.01, 1.01)
