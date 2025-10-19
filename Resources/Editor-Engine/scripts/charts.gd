@icon("res://Resources/Editor-Engine/Icons/chart.png")

extends Resource
##The file where you store the data for your song, the song chart!
class_name  Chart

@export_group("Chart Settings")
##The [b][color=navyblue]name[/color][/b] of the chart
@export var name : String
##The [b][color=lime]rhythem[/color][/b] rate of the song
@export var bpm : int = 100
##Is there a [b][color=hotpink]voice track[/color][/b] to add to the chart
@export var voices = true
##How [b][color=lightskyblue]fast[/color][/b] the chart goes
@export var scroll_speed = 1.0

@export_subgroup("Song Metadata")

##The author for the song
@export var artist : String

##The album the song belongs to
@export var album : String

@export_group("Assets")
##The [b][color=skyblue]player[/color][/b] for the chart
@export var bf : Array = ["", 0]
##The [b][color=darkorchid]opponent[/color][/b] for the chart
@export var dad : Array = ["", 0]
##The character acting as [b][color=deeppink]girlfriend[/color][/b] in the chart
@export var gf : Array = ["", 0]
##The [b][color=darkblue]environment[/color][/b] for the song
@export var stage : String


@export_group("Chart Data")
##The chart data (the arrows, events, etc...)
@export var chart_data = {
	"notes" : {},
	"events" : {},
	"lyrics" : {}
}

##Returns the notes in the chart
func get_note_data():
	return chart_data.notes

##Returns a note at it's respective time
func get_note_at_time(time : float):
	
	return chart_data.notes.get(time)

##Returns the events in the chart
func get_event_data():
	return chart_data.events

##Returns the lyrics in the chart
func get_lyric_data():
	return chart_data.lyrics
