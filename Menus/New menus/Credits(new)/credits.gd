extends Node2D

##Determines who appears on the credit menu and their order. This includes the description icon, color, etc. The entire credits menu relys on this varible
@export var credits = [
	"Main Team",
	["superL132", "res://Resources/Texture/icons/credits/superL132.png", "The director", "DBBE00", "https://linktr.ee/superl132"],
	["mastertrapmon", "res://Resources/Texture/icons/credits/mastertrapmon.png", "The creator of Koen and Aster", "4888C5", "https://www.youtube.com/@mastertrapmon1588"],
	["Mega Mango", "res://Resources/Texture/icons/credits/missing_icon.png", "Creator of the songs : Boggle and Blurt", "B8900D", "https://www.youtube.com/channel/UC-LPKqJ8hRiRynq9sjreP7Q"],
	["Star Verse", "res://Resources/Texture/icons/credits/missing_icon.png", "The creator of the Koen Aster song", "17003D", "https://www.youtube.com/@StarVerseVictory"],
	"Assistants",
	["Chocok", "res://Resources/Texture/icons/credits/missing_icon.png", "Assistant artist", "23FF86", "https://www.deviantart.com/enchantedchoco"],
	"Play Testers",
	["Rey_The_Confused", "res://Resources/Texture/icons/credits/missing_icon.png", "#1 Bug finder, idk how he does it, lol", "FFFFFF", "https://www.youtube.com/@Rey_TheConfused"],
	["kitsune", "res://Resources/Texture/icons/credits/missing_icon.png", "desc", "FFFFFF", null],
	["Rosa", "res://Resources/Texture/icons/credits/missing_icon.png", "desc", "FFFFFF", null]
]
@export var titleSettings = {
	"Main Team" : [Color.TEAL, "Main Team"],
	"Assistants" : ["555555", "Assistants"],
	"Play Testers" : ["555555", "Play Testers"]
}

#template templates!
#Formula: ["name", "photo_path", "description", "Color_Hex", "person_url"]
#["name", "res://Resources/Texture/icons/credits/missing_icon.png", "desc", "FFFFFF", null]
#"Name (important)" : ["FFFFFF", "desc"]

#template stuff
@onready var templateLabel = $"Credit Labels/Control/Template"
#@onready var templateIcon = $"Credit Labels/Control/Template/TextureRect"
@onready var templateHeader = $"Credit Labels/Control/Title"

@onready var camera = $Camera2D
@onready var bg = $Camera2D/Sprite2D
@onready var descPanel = $Camera2D/Panel
@onready var descLabel = $Camera2D/Panel/Label

var menu_option = 0
var scroll_multiplier = 150
var can_control = true

func _ready():
	
	#$freakyMenu.play(MenuMannager.menu_music_time)
	$Camera2D/Anim.play_backwards("selected")
	_credits_names()

func _credits_names():
	
	for i in credits.size():
		print(typeof(credits[i]))
		if typeof(credits[i]) == 28:
			var templateLabelDup = templateLabel.duplicate()
			#var templateIconDup = templateIcon.duplicate()
			templateLabelDup.position.y = i * scroll_multiplier
			templateLabelDup.text = credits[i][0]
			templateLabelDup.id = i
			$"Credit Labels/Control".add_child(templateLabelDup)
			templateLabelDup.icon.texture = load(credits[i][1])
	
		elif typeof(credits[i]) == 4:
			var templateHeaderDup = templateHeader.duplicate()
			templateHeaderDup.position.y = i * scroll_multiplier
			templateHeaderDup.text = credits[i]
			$"Credit Labels/Control".add_child(templateHeaderDup)

func _process(delta):
	
	_camera_stuff(delta)
	_update_other()

func _update_other():
	pass
	#if typeof(credits[menu_option]) == 28:
		#descLabel.text = credits[menu_option][2]
		#print("name")
	#elif typeof(credits[menu_option]) == 4:
		#titleSettings.get(credits[menu_option])[1]
		#print("title")
	#print(typeof(credits[menu_option]))

func _camera_stuff(delta):
	
	camera.position.y = lerpf(camera.position.y, menu_option * scroll_multiplier, delta * 3)
	
	if can_control:
		if Input.is_action_just_pressed("uiUp") or Input.is_action_just_pressed("uiDown"):
			menu_option += Input.get_axis("uiUp","uiDown")
			$scrollMenu.play()
	
	if can_control:
		if Input.is_action_just_pressed("uiBack"):
			can_control = false
			$Camera2D/Anim.play("selected")
			$BackSceneTimer.start()
			$cancelMenu.play()
	
	if can_control:
		if Input.is_action_just_pressed("uiConfirm"):
			if typeof(credits[menu_option]) == 28:
				if not credits[menu_option][4] == null:
					OS.shell_open(credits[menu_option][4])
					$confirmMenu.play()
				else:
					$cancelMenu.play()
	
	if menu_option < 0:
		menu_option = credits.size() - 1
	if menu_option > credits.size() - 1:
		menu_option = 0
	
	if typeof(credits[menu_option]) == 28:
		descLabel.text = credits[menu_option][2]
		bg.modulate = lerp(bg.modulate, Color(credits[menu_option][3]), delta)
	elif typeof(credits[menu_option]) == 4:
		descLabel.text = titleSettings.get(credits[menu_option])[1]
		bg.modulate = lerp(bg.modulate, Color(titleSettings.get(credits[menu_option])[0]), delta)
	

func _on_back_scene_timer_timeout():
	MenuMannager.menu_music_time = $freakyMenu.get_playback_position()
	get_tree().change_scene_to_file("res://Menus/New menus/Main Menu/new_main_menu.tscn")
