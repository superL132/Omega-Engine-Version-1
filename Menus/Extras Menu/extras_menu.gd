extends Node2D


var menu_option = 0
var total_options = 1
var can_control = true
var action = "idle"

@onready var camera = $Camera2D

func _ready():
	
	$"enter gradient/AnimationPlayer".play("enter")
	MenuMannager.coming_from_extra_menu = true


func _process(delta):
	
	if can_control:
		_options(delta)
	_camera(delta)

func _camera(delta):
	
	camera.position.y = lerpf(camera.position.y, menu_option * 150, delta * 3)

func _options(delta):
	
	if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
		menu_option += Input.get_axis("uiUp", "uiDown")
		$scrollMenu.play()
		if menu_option == 1:
			$Camera2D/DEBUGGG3/AnimationPlayer.play("scroll")
			$Text/Label2/AnimationPlayer.play("flash")
			$ColorRect/AnimationPlayer2.play("enter")
			$Camera2D/AnimationPlayer.play("debug idle")
		else:
			$Camera2D/DEBUGGG3/AnimationPlayer.play("RESET")
			$Text/Label2/AnimationPlayer.play("RESET")
			$ColorRect/AnimationPlayer2.play_backwards("enter")
			$Camera2D/AnimationPlayer.play("RESET")
	
	if Input.is_action_just_pressed("uiBack"):
		can_control = false
		action = "back"
		$"enter gradient/AnimationPlayer".play_backwards("enter")
		$cancelMenu.play()
		$changeSceneTimer.start()
	
	if Input.is_action_just_pressed("uiConfirm"):
		can_control = false
		$confirmMenu.play()
		action = "select"
		MenuMannager.menu_music_player.stop()
		$changeSceneTimer.start()
	
	if menu_option > 0:
		menu_option = total_options
	if menu_option < total_options:
		menu_option = 0
	
	if menu_option == 1:
		if OS.has_feature("debug"):
			$Text/Label2.modulate = Color.GREEN
		else:
			$Text/Label2.modulate = Color.RED
	else:
		$Text/Label2.modulate = Color.WHITE


func _on_change_scene_timer_timeout():
	if action == "back":
		get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")
	
	if action == "select":
		
		if menu_option == 0:
			get_tree().change_scene_to_file("res://Menus/Editors/Charter(new)/chart.tscn")
