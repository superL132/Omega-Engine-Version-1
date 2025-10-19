extends Node2D

#N.B:
#I fucked something up with the code:
#saving and loading is something else and it could corrupt your chart file...
#Use it if you want your chart fucked up! (use it at your own risk)

@onready var tabBarN = $"Control Panel/TabBar"

##The chart that is going to be loaded on startup [u](debugging only)[/u]
@export var preload_chart : String

var file_dir
var file_open = false
var file_as_text
var file_as_json
var file_as_resource = Chart.new()
var file
var file_name

#file info
var file_name_special
var file_notes
var file_events
var file_bpm
var file_voices = true

var file_difficulty = "normal"

var audioInst = preload("res://Resources/Music/Songs/blurt/Inst.ogg")
var audioVoices
var totalSongTime
var totalSongBpm
var currentSongBpm
var currentSongTime = 0

var chart_scroll = 0
var totalSection = 0
var section = 0
var song_playing = false
var chart_music_play = false


func _ready():
	if MenuMannager.menu_music_player.playing:
		MenuMannager.menu_music_player.stop()
	
	$"Control Panel/ChartReferencer1".hide()
	_reset_chart_settings("chart")
	_notification_bar_setup()
	_reload_list_items()
	_update_tabs(0)
	if not preload_chart == null:
		_open_chart(preload_chart)

func _open_chart(chart_name : String = ""):
	
	chart_name = chart_name.to_lower()
	var path = str("res://Songs/", chart_name, "/", file_difficulty, ".tres")
	
	if not chart_name == "":
		if ResourceLoader.exists(path):
			_open_file(path)
			_grab_file_info()
		else:
			pass
		$"Control Panel/Panel/sections/Song/song".text = chart_name
	

func _calculate_stuff():
	
	if file:
		totalSongBpm = round(file.bpm / 60 * totalSongTime)
		totalSection = totalSongBpm / 4
		print(totalSongBpm)

func _reload_list_items():
	#var events_file = load("res://Data/events_data.json")
	var events_file = JSON.parse_string(FileAccess.open("res://Data/events_data.json", FileAccess.READ).get_as_text())
	var stages_file = JSON.parse_string(FileAccess.open("res://Data/stages.json", FileAccess.READ).get_as_text())
	var charaters_file = JSON.parse_string(FileAccess.open("res://Data/characters.json", FileAccess.READ).get_as_text())
	
	for i in events_file.size():
		$"Control Panel/Panel/sections/Events/event list".add_item(events_file[i][0])
	for i in stages_file.size():
		$"Control Panel/Panel/sections/Song/stage".add_item(stages_file[i])
	for i in charaters_file.size():
		$"Control Panel/Panel/sections/Song/Bf".add_item(charaters_file[i])
		$"Control Panel/Panel/sections/Song/Gf".add_item(charaters_file[i])
		$"Control Panel/Panel/sections/Song/Op".add_item(charaters_file[i])
	
	FileAccess.open("res://Data/events_data.json", FileAccess.READ).close()
	FileAccess.open("res://Data/characters.json", FileAccess.READ).close()

func _notification_bar_setup():
	$notification.offset.y = get_window().size.y
	$notification/Node2D/notification.size = Vector2(0, 0)
	$notification/Node2D/notification.position.y = 0 - $notification/Node2D/notification.size.y
	

func _process(delta):
	
	_update_chart_scroller()
	_update_extra_stuff()
	

func _update_chart_scroller():
	var grid = $Chart/Grid
	
	if Input.is_action_just_released("mouce wheel up"):
		chart_scroll += 20
	if Input.is_action_just_released("mouce wheel down"):
		chart_scroll += -20
	
	if Input.is_action_just_pressed("space"):
		if song_playing:
			song_playing = false
			$Inst.stop()
			if chart_music_play:
				$"Autistic Expressive".stream_paused = false
		else:
			song_playing = true
			$Inst.play(currentSongTime)
			if chart_music_play:
				$"Autistic Expressive".stream_paused = true
	
	if file:
		if song_playing:
			currentSongTime = $Inst.get_playback_position()
			var scroll_play = $Inst.get_playback_position() * currentSongBpm
			if scroll_play < (-45 * 0.75) * 16:
				scroll_play = scroll_play - (section * (-45 * 0.75) * 16)
			chart_scroll = scroll_play
	
	#if chart_scroll > 324:
	#	chart_scroll = 324
	
	if file:
		if not song_playing:
			currentSongTime = ((-chart_scroll + section * ((45 * 0.75) * 16)) / (totalSection * ((45 * 0.75) * 16))) * totalSongTime
	
	#printt((-45 * 0.75) * 16)
	
	if section == 0:
		if chart_scroll > 0:
			chart_scroll = 0
	else:
		if chart_scroll > 0:
			chart_scroll = (-45 * 0.75) * 16
			section += -1
	
	if chart_scroll < (-45 * 0.75) * 16:
		chart_scroll = 0
		section += 1
	
	grid.position.y = chart_scroll + 324.0

func _update_extra_stuff():
	
	#if not file == load(str("res://Songs/", file_name, "/", file_difficulty, ".tres")):
	#	GameplayMannager.needSave = true
	#	print("need save")
	
	if file:
		#print(totalSongTime)
		$"other labels/Section".text = str("Section: ", section)
		$"other labels/current time".text = str(snappedf(currentSongTime, 0.01), " / ", snappedf(totalSongTime, 0.01))
		$"other labels/Beat".text = str("Beat: ", $Conductor.get_beat_at(currentSongTime))
		$"other labels/Step".text = str("Step:", $Conductor.get_step_at(currentSongTime))
	else:
		$"other labels/Section".text = "Section: 0"
		$"other labels/current time".text = "No Song Loaded"
		$"other labels/Beat".text = "Beat: 0"
		$"other labels/Step".text = "Step: 0"

func _open_file(path : String):
	file_dir = path
	#if path:
	file_as_json = FileAccess.open(path, FileAccess.READ_WRITE)
	file = load(path)
	
	

func _grab_file_info():
	if file:
		
		print("File successfully loaded! The engine is processing the info...")
		file_name_special = file.name
		file_notes = file.get_note_data()
		file_events = file.get_event_data()
		currentSongBpm = file.bpm
		
		$Conductor.tempo = $"Control Panel/Panel/sections/Song/BPM".value
		
		audioInst = load(str("res://Resources/Music/Songs/", file.name.to_lower(), "/Inst.ogg"))
		audioVoices = load(str("res://Resources/Music/Songs/", file.name.to_lower(), "/Voices.ogg"))
		print(str("res://Resources/Music/Songs/", file.name.to_lower(), "/Voices.ogg"))
		
		#print("Name : ", file_name_special, ", BPM : ", file_bpm, ", Note Data : ", file_notes, ", Events Data : ", file_events)
		_set_chart_settings()
		_calculate_stuff()
	else:
		printerr("An error occured while grabbing file info, the engine is trying again... Try another path")
		_open_file(file_dir)

func _set_chart_settings():
	
	var charaters_file = JSON.parse_string(FileAccess.open("res://Data/characters.json", FileAccess.READ).get_as_text())
	
	$Inst.stream = audioInst
	$Voices.stream = audioVoices
	
	
	#print($Inst.stream.get_length())
	totalSongTime = $Inst.stream.get_length()
	
	$"Control Panel/Panel/sections/Song/song/voices".button_pressed = file.voices
	$"Control Panel/Panel/sections/chart/BPM".value = file.bpm
	$"Control Panel/Panel/sections/Song/BPM".value = file.bpm
	$"Control Panel/Panel/sections/Song/speed".value = file.scroll_speed
	$"Control Panel/Panel/sections/Song/Bf".selected = file.bf[1]
	$"Control Panel/Panel/sections/Song/Gf".selected = file.gf[1]
	$"Control Panel/Panel/sections/Song/Op".selected = file.dad[1]
	

func _update_tabs(tab):
	
	$"Control Panel/Panel/sections/chart".hide()
	$"Control Panel/Panel/sections/Events".hide()
	$"Control Panel/Panel/sections/Song".hide()
	if tab == 0:
		$"Control Panel/Panel/sections/chart".show()
	if tab == 1:
		$"Control Panel/Panel/sections/Events".show()
	if tab == 4:
		$"Control Panel/Panel/sections/Song".show()

func _reset_chart_settings(setting : String):
	if setting == "chart":
		$"Control Panel/Panel/sections/chart/BPM".value = 100
		$"Control Panel/Panel/sections/chart/vortex".button_pressed = true
		$"Control Panel/Panel/sections/chart/InstVol".value = 0.6
		$"Control Panel/Panel/sections/chart/VoicesVol".value = 1.0
		$"Control Panel/Panel/sections/Song/BPM".value = 100
		$"Control Panel/Panel/sections/Song/speed".value = 1.0
		


func _on_tab_bar_tab_changed(tab):
	_update_tabs(tab)

func _on_reload_json_pressed():
	
	if not $"Control Panel/Panel/sections/Song/song".text == "":
		if ResourceLoader.exists(str("res://Songs/", $"Control Panel/Panel/sections/Song/song".text.to_lower(), "/normal.tres")):
			_open_chart($"Control Panel/Panel/sections/Song/song".text)
			file_name = $"Control Panel/Panel/sections/Song/song".text.to_lower()
			$confirmMenu.play()
			$"Control Panel/Panel/sections/Song/song".text = $"Control Panel/Panel/sections/Song/song".text.to_lower()
		else:
				push_notification("res://Resources/Texture/Menus/Charter/Ui/Notifications/error.svg", "No Exist")
				$cancelMenu.play()
		if not file == null:
			if ResourceLoader.exists(str("res://Songs/", $"Control Panel/Panel/sections/Song/song".text, "/normal.tres")):
				push_notification("res://Resources/Texture/Menus/Charter/Ui/Notifications/confimed.svg", "LOADED!")
			else:
				push_notification("res://Resources/Texture/Menus/Charter/Ui/Notifications/error.svg", "No Exist")
				$cancelMenu.play()
		else:
			push_notification("res://Resources/Texture/Menus/Charter/Ui/Notifications/error.svg", "ERROR...")
			$cancelMenu.play()
	else:
		push_notification("res://Resources/Texture/Menus/Charter/Ui/Notifications/error.svg", "NO WORDS")
		$cancelMenu.play()
	

func push_notification(image : String, message : String):
	var notifTexture = $notification/Node2D/notification
	var label = $notification/Node2D/notification/Label
	
	$notification/Node2D/AnimationPlayer.play("RESET")
	$notification/Node2D/AnimationPlayer.play("notif")
	notifTexture.texture = load(image)
	label.text = message
	
	_notification_bar_setup()


func _on_voices_toggled(toggled_on):
	if file:
		file.voices = toggled_on
		
		#im so darned stupid bruh... *face palm*
		
	

func _on_bpm_value_changed(value):
	if file:
		file.bpm = value

func _save_data():
	
	ResourceSaver.save(file, file_dir)
	print("settings saved")
	$scrollMenu.play()
	push_notification("res://Resources/Texture/Menus/Charter/Ui/Notifications/saving.svg", "SAVED!")


func _on_save_pressed():
	_save_data()


func _on_speed_value_changed(value):
	if file:
		file.scroll_speed = value


func _on_bf_item_selected(index):
	print(index)
	var charaters_file = JSON.parse_string(FileAccess.open("res://Data/characters.json", FileAccess.READ).get_as_text())
	
	if file:
		file.bf = [charaters_file[index - 1], index]


func _on_gf_item_selected(index):
	print(index)
	var charaters_file = JSON.parse_string(FileAccess.open("res://Data/characters.json", FileAccess.READ).get_as_text())
	
	if file:
		file.gf = [charaters_file[index - 1], index]


func _on_op_item_selected(index):
	print(index)
	var charaters_file = JSON.parse_string(FileAccess.open("res://Data/characters.json", FileAccess.READ).get_as_text())
	
	if file:
		file.dad = [charaters_file[index - 1], index]


func _on_conductor_new_beat(current_beat, measure_relative):
	#$MetronomeTick.play()
	pass


func _on_exit_pressed():
	$Chart/Grid.set_process(false)
	MenuMannager.menu_music_player.play()
	$cancelMenu.play()
	$exitSceneTimer.start()
	$"Autistic Expressive".stop()


func _on_exit_scene_timer_timeout():
	MouseMannager._set_cursor("HIDE")
	get_tree().change_scene_to_file("res://Menus/Extras Menu/extras_menu.tscn")


func _on_tab_bar_tab_hovered(tab):
	#MouseMannager._set_cursor("pointer")
	$AudioStreamPlayer.play()


func _on_charter_music_toggled(toggled_on):
	# The node name is not meant to be an offence, I just don't know how to spell... (I'm autistic btw)
	if song_playing:
		$"Control Panel/Charter Music".toggle_mode = false
	
	if toggled_on:
		$"Autistic Expressive".volume_db = -80
		var tween = create_tween()
		tween.tween_property($"Autistic Expressive", "volume_db", 0.0, 8)
		tween.play()
		$"Autistic Expressive".play()
	else:
		$"Autistic Expressive".stop()
