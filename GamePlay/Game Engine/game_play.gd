@tool
extends Node

@export_category("Debug Settings")
## This is for [b][u]debug purposes only[/u][/b]. Put in the directory of a Chart. If used, be sure to remove it afterwards. This variable is also used by the system. An automatic system will be installed in a later update.
@export_file("*.tres") var chart_dir : String

var chart : Chart

var audio_dir = "res://Resources/Music/Songs/"

var inst_dir
var voices_dir
var inst_audio
var voices_audio

var stage_dir
var stage



func _ready():
	MenuMannager.menu_music_player.stop()
	_load_chart()

func _load_chart():
	if not chart_dir == null:
		chart = load(chart_dir)
		inst_dir = audio_dir + chart.name.to_lower() + "/Inst.ogg"
		voices_dir = audio_dir + chart.name.to_lower() + "/Voices.ogg"
		
		inst_audio = load(inst_dir)
		voices_audio = load(voices_dir)
		
		stage_dir = "res://Stages/" + chart.stage + "/stage.tscn"
		stage = load(stage_dir)
		
		_setup_nodes()

func _setup_nodes():
	$Audio/Inst.stream = inst_audio
	$Audio/Voices.stream = voices_audio
	$Audio/Inst.play()
	$Audio/Voices.play()
	
	$Stage.add_child(stage)
