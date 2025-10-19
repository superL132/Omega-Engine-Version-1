extends Node2D

@onready var press_start = $"press start"

var audio_bus = preload("res://default_bus_layout.tres")

var can_control = true

func _ready():
	
	#$freakyMenu.play(MenuMannager.menu_music_time)
	$Conductor.stream_player = MenuMannager.menu_music_player.get_path()
	$"Logo Bumpin/AnimationPlayer2".play("enter")
	$Camera2D/anim.play_backwards("enter")
	if not Settings.preferences.shaders:
		$ColorRect3.free()



func _process(delta):
	
	
	if can_control:
		_update_input()
	
	$"press start/Parallax2D".scroll_offset.x += 1
	
	
func _update_input():
	
	if Input.is_action_just_pressed("uiConfirm"):
		can_control = false
		_selected()

func _bpm_test():
	
	pass

func _selected():
	
	press_start.play("selected")
	$confirmMenu.play()
	$Camera2D/anim.play("selected")
	$Camera2D/scenechange.start()
	$Camera2D/ColorRect2/AnimationPlayer.play("flash")
	$"press start/Parallax2D/ColorRect".hide()
	$"press start/Parallax2D/ColorRect2".show()

func _on_scenechange_timeout():
	MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
	get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")




func _on_conductor_new_beat(current_beat, measure_relative):
	$"Logo Bumpin/AnimationPlayer".play("bump")
	#print("bump")
