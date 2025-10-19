extends Node

var menu_music_time = 0
var last_main_option = 1
var startup = true
var version_startup = true

#useless shit
var freeplay_toggle = false
var coming_from_extra_menu = false

var globalUiScene = preload("res://Resources/Scenes/global_ui.tscn")
var globalUiSceneIntance = globalUiScene.instantiate()

var menu_music

var menu_music_player = AudioStreamPlayer.new()

func _ready():
	add_child(globalUiSceneIntance)
	
	if ProjectSettings.get_setting("omega/mods/menu_music") == null:
		menu_music = ProjectSettings.get_setting("omega/mods/menu_music")
	else:
		menu_music = "res://Resources/Music/Menu/freakyMenu.ogg"
	
	if not get_tree().has_group("Freeplay"):
		_setup_audio()
		menu_music_player.play()
	
	get_tree().tree_changed.connect(_scene_changed)

func _setup_audio():
	menu_music_player.stream = load(menu_music)
	menu_music_player.bus = "Music"
	add_child(menu_music_player)

func _scene_changed():
	
	pass

func _freeplay_request(toggle : bool):
	
	var audio_tween = create_tween()
	
	audio_tween.finished.connect(_shut_off_music)
	freeplay_toggle = toggle
	
	if toggle:
		print("Entering freeplay : Shutting off main menu music...")
		audio_tween.set_ease(Tween.EASE_IN)
		audio_tween.set_trans(Tween.TRANS_BOUNCE)
		audio_tween.tween_property(menu_music_player, "pitch_scale", 0, 1.5)
	else:
		_setup_audio()
		menu_music_player.play()
		audio_tween.set_ease(Tween.EASE_OUT)
		audio_tween.set_trans(Tween.TRANS_ELASTIC)
		audio_tween.tween_property(menu_music_player, "pitch_scale", 1, 1.5)

func _shut_off_music():
	
	if freeplay_toggle:
		print("Music Terminated")
		menu_music_player.stop()

func _process(delta):
	#var press_start = load("res://Menus/New menus/Press Start/press_start.tscn")
	
	
	
	if get_tree().has_group("Low Volume"):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerpf(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")), -12, delta / 2))
		AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 1).cutoff_hz = lerpf(AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 1).cutoff_hz, 2000, delta / 2)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerpf(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")), 0, delta / 2))
		AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 1).cutoff_hz = lerpf(AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 1).cutoff_hz, 20500, delta / 2)
	
	
	#if not get_tree().has_group("GlobalUi"):
		#get_tree().root.add_child(globalUiSceneIntance)
