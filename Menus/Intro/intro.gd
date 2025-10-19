extends Node2D

var press_start = preload("res://Menus/New menus/Press Start/press_start.tscn")

##Random phrases used in the intro (NB: Use only 2 in for the PackedStringArray)
@export var random_phrases : Array[PackedStringArray]
@export_file("*.tscn") var next_scene = "res://Menus/New menus/Press Start/press_start.tscn"



func _ready():
	MenuMannager.menu_music_time = 9.5
	_random_message()
	
	press_start = load(next_scene)

func _process(delta):
	
	if Input.is_action_just_pressed("uiConfirm"):
		print($freakyMenu.get_playback_position())
		MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
		get_tree().change_scene_to_packed(press_start)

func _random_message():
	
	var phrase1
	var phrase2
	var randomArray = random_phrases[randf_range(0, random_phrases.size())]
	
	phrase1 = randomArray[0]
	phrase2 = randomArray[1]
	
	$"words/Random phrases/Label".text = phrase1
	$"words/Random phrases/Label3".text = phrase2
	
	print("the following phrases are going to be used :")
	print(phrase1)
	print(phrase2)

func _on_animation_player_animation_finished(anim_name):
	print($freakyMenu.get_playback_position())
	MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
	get_tree().change_scene_to_packed(press_start)
