extends Node2D

@onready var anim = $Camera2D/anim
@onready var camera = $Camera2D
@onready var music = $music
@onready var album_cover = $Camera2D/album_cover
@onready var song_label = $Camera2D/album_cover/Control/Label
@onready var vinyl = $Camera2D/album_cover/vinyl
@onready var time_bar = $Camera2D/album_cover/time
@onready var time_bar_label = $Camera2D/album_cover/time/Label
@onready var bg = $Camera2D/bg

var menu_option = 1
var total_options = 3
var song_playing = null
var song_label_scroll = false

var vinyl_slid_out = false

var song_list : Array = ["boggle", "blurt", "the koen aster song"]
var playlist : Array = ["res://Resources/Music/Songs/blurt/Inst.ogg", "res://Resources/Music/Menu/freakyMenu.ogg"]
var song_info : Dictionary = {"???" : {"artist" : "???", "album" : "???"},"Blurt" : {"artist" : "Mega Mango", "album" : "Koen and Aster"}, "Boggle" : {"artist" : "Mega Mango", "album" : "Koen and Aster"}, "The Koen Aster Song" : {"artist" : "Star Verse", "album" : "Koen and Aster"}}
var bg_color : Array = ["353E47", "B59B62", "2D3A4D"]

#preload assets{
#songs
var preloadSong_blurt = preload("res://Resources/Music/Songs/blurt/Inst.ogg")
var preloadSong_boggle = preload("res://Resources/Music/Songs/boggle/Inst.ogg")
var preloadSong_theKoenAsterSong = preload("res://Resources/Music/Songs/the koen aster song/Inst.mp3")

#album covers
var preloadAlbumCover_koen_and_aster = preload("res://Resources/Texture/Menus/freeplay/album covers/Koen and Aster.png")
var preloadAlbumCover_missing = preload("res://icon.svg")

#other files
var preloadOther_bg_color_styleBox = preload("res://Menus/Freeplay/other/bg_color_styleBox.tres")




func _ready():
	bg_color.resize(total_options)
	playlist.resize(total_options)
	
	bg.self_modulate = Color(bg_color[0])
	
	_update_song()
	
	anim.play_backwards("selected")

func _process(delta):
	
	_update_options()
	_update_camera(delta)
	_update_time_bar()
	_check_mouce_wheel()
	
	if song_label_scroll:
		song_label.position.x += -1
	if song_label.position.x < 0 - song_label.size.x + 30:
		song_label.position.x = song_label.size.x
	
	$"Camera2D/album_cover/vinyl/vinyl base2/TextureRect".rotation_degrees += -1
	$"Camera2D/album_cover/vinyl/vinyl base2/TextureRect".texture = album_cover.texture
	$Camera2D/album_cover/album_cover_outline.texture = album_cover.texture
	
	album_cover.position = lerp(album_cover.position, Vector2(213, -42), delta * 5)

func _update_camera(delta):
	
	camera.position.y = lerpf(camera.position.y, (menu_option - 1) * 150, delta * 3)
	
	bg.self_modulate = lerp(bg.self_modulate, Color(bg_color[menu_option - 1]), delta)

func _update_options():
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
		
		
	
	if Input.is_action_just_pressed("uiBack"):
		anim.play("selected")
		$"music/music effects".play("pitch out")
		$cancelMenu.play()
		$changeSceneBackTimer.start()
	
	
	if menu_option < 1:
		menu_option = total_options
	if menu_option > total_options:
		menu_option = 1
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		_update_song()

func _update_time_bar():
	var total_time = music.stream.get_length()
	var curent_time = music.get_playback_position()
	
	var current_time_string : String
	var total_time_string : String
	
	time_bar.max_value = total_time
	time_bar.value = curent_time
	
	preloadOther_bg_color_styleBox.bg_color = bg.self_modulate
	
	
	
	#current_time_string = str(snapped(round(curent_time / 60), 1), ":", snapped(abs(round((curent_time / 60 - round(curent_time / 60))* 60)), 1))
	if round(wrap(curent_time, 0, 60)) < 10:
		current_time_string = str(snapped(round(curent_time / 60), 1), ":0", snapped(round(wrap(curent_time, 0, 60)), 1))
	else:
		current_time_string = str(snapped(round(curent_time / 60), 1), ":", snapped(round(wrap(curent_time, 0, 60)), 1))
	
	if round(wrap(total_time, 0, 60)) < 10:
		total_time_string = str(snapped(round(total_time / 60), 1), ":0", snapped(round(wrap(total_time, 0, 60)), 1))
	else:
		total_time_string = str(snapped(round(total_time / 60), 1), ":", snapped(round(wrap(total_time, 0, 60)), 1))
	
	time_bar_label.text = str(current_time_string, " / ", total_time_string)
	
func _update_song():
	
	$"music/music effects".play("RESET")
	$"music/music effects".play("fade in")
	album_cover.position = Vector2(883, -42)
	song_label_scroll = false
	$Camera2D/album_cover/Control/Timer.start()
	
	
	$Camera2D/album_cover/vinyl/AnimationPlayer.play("RESET")
	$"Camera2D/album_cover/vinyl/vinyl slide".start()
	
	
	
	if menu_option == 1:
		song_playing = "Boggle"
		music.stream = preloadSong_boggle
	elif menu_option == 2:
		song_playing = "Blurt"
		music.stream = preloadSong_blurt
	elif menu_option == 3:
		song_playing = "The Koen Aster Song"
		music.stream = preloadSong_theKoenAsterSong
	else:
		song_playing = "???"
	music.play()
	
	if song_info.get(song_playing).get("album") == "Koen and Aster":
		album_cover.texture = preloadAlbumCover_koen_and_aster
	else:
		album_cover.texture = preloadAlbumCover_missing
	
	song_label.text = str(song_playing, " by ", song_info.get(song_playing).get("artist"), ", ", song_info.get(song_playing).get("album"))
	song_label.position = Vector2.ZERO
	
	print("Change Song to " + song_playing)

func _check_mouce_wheel():
	
	if Input.is_action_just_released("mouce wheel up"):
		menu_option += -1
		_update_song()
		$scrollMenu.play()
	if Input.is_action_just_released("mouce wheel down"):
		menu_option += 1
		_update_song()
		$scrollMenu.play()
	
	if menu_option < 1:
		menu_option = total_options
	if menu_option > total_options:
		menu_option = 1

func _on_change_scene_back_timer_timeout():
	MenuMannager.menu_music_time = 0
	get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")


func _on_timer_timeout():
	song_label_scroll = true


func _on_vinyl_slide_timeout():
	$Camera2D/album_cover/vinyl/AnimationPlayer.play("slide out")
