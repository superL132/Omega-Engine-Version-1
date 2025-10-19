extends Node

@onready var root = $".."

var file
var chart_notes
var chart_events

var song_position = 0.0

func _ready():
	
	_get_file()
	_load_chart()

func _get_file():
	
	file = load(root.chart)

func _process(delta):
	
	if $"../Inst".playing:
		song_position = $"../Inst".get_playback_position() #+ AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
	
	song_position = snappedf(song_position, 0.01)
	
	var current_arrow = file.get_note_at_time(song_position)
	print(current_arrow)
	
	#print(file.get_note_at_time($"../Inst".get_playback_position()))
	#print(song_position)
	
	if not current_arrow == null:
		print(current_arrow)
	
	if current_arrow == "PR":
		$"../characters/Main/BF".sprite.play("BF NOTE RIGHT")
	

func _load_chart():
	
	chart_notes = file.chart_data.notes
	chart_events = file.chart_data.events
	
	print("Chart Loaded :")
	print(chart_notes, chart_events)
