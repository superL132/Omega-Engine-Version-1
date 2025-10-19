extends Node2D

@onready var camera = $Camera2D

var menu_option = 1
var total_options = 4
var control = true

#scenes
var option_scene = preload("res://Menus/Options/options.tscn")

func _ready():
	
	$freakyMenu.play(MenuMannager.menu_music_time)

func _process(delta):
	
	_update_camera(delta)
	if control:
		_update_option()
	_update_words()
	
	$Camera2D/Label.text = ("Version : " + ProjectSettings.get_setting("application/config/version"))

func _update_camera(delta):
	if menu_option < 4:
		camera.position.y = lerp(camera.position.y, float(1) * 150, delta * 5)
	if menu_option > 3:
		camera.position.y = lerp(camera.position.y, float(4) * 150, delta * 5)

func _update_option():
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
		print(menu_option)
	if Input.is_action_just_pressed("uiConfirm"):
		$confirmMenu.play()
		_selected()
	
	if menu_option < 1:
		menu_option = total_options
	
	if menu_option > total_options:
		menu_option = 1

func _selected():
	if menu_option == 3:
		control = false
		$"change scene".start()

func _update_words():
	if menu_option == 1:
		$"Story Mode".play("selected")
	else:
		$"Story Mode".play("basic")
	
	if menu_option == 2:
		$"Free Play".play("selected")
	else:
		$"Free Play".play("basic")
	
	if menu_option == 3:
		$"Options".play("selected")
	else:
		$"Options".play("basic")
	
	if menu_option == 4:
		$"Credits".play("selected")
	else:
		$"Credits".play("basic")


func _on_change_scene_timeout():
	MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
	get_tree().change_scene_to_file("res://Menus/Options/options.tscn")
