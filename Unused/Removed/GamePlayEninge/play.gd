extends Node2D


@export_file("*.tres") var chart : String

@onready var camera = $Camera

var file

func _ready():
	
	
	
	if MenuMannager.menu_music_player.playing:
		MenuMannager.menu_music_player.stop()
	
	_grab_file_info()
	_setup_nodes()
	_startup_nodes()

func _setup_nodes():
	
	_load_stage()
	$Inst.stream = load(str("res://Resources/Music/Songs/", _grab_file_info("name"), "/Inst.ogg"))
	if file.voices:
		$Voices.stream = load(str("res://Resources/Music/Songs/", _grab_file_info("name"), "/Voices.ogg"))
	$Conductor.tempo = _grab_file_info("tempo")

func _startup_nodes():
	
	$Inst.play()
	$Voices.play()

func _process(delta):
	
	camera.position += Input.get_vector("left", "right", "up", "down") * 15
	

func _grab_file_info(info_request : String = ""):
	
	if file == null:
		print("No chart file loaded, opening chart")
		file = load(chart)
		if file:
			print("File loaded succesfully")
	
	if file:
		if info_request == "stage":
			return file.stage[0]
		if info_request == "tempo":
			return file.bpm
		if info_request == "name":
			return chart.get_slice("/", 4)

func _load_stage():
	#_grab_file_info("stage")
	var stage_path# = _grab_file_info("stage")
	add_child(load("res://Stages/Stage/stage.tscn").instantiate())


func _on_conductor_new_beat(current_beat, measure_relative):
	
	var gf_data_file = load("res://Characters/Main/Gf/data.tres")
	var bf_data_file = load("res://Characters/Main/Bf/data.tres")
	var dad_data_file = load("res://Characters/Main/Dad/data.tres")
	
	if current_beat % 2 == 0:
		$"characters/Back Characters/Gf".sprite.play(gf_data_file.idle)
		$characters/Main/Dad.sprite.play(dad_data_file.idle)
		$characters/Main/BF.sprite.play(bf_data_file.idle)
	if current_beat % 2 == 1:
		if gf_data_file.twoIdle:
			$"characters/Back Characters/Gf".sprite.play(gf_data_file.idle2)
		else:
			$"characters/Back Characters/Gf".sprite.play(gf_data_file.idle)
