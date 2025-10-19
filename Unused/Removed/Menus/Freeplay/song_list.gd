extends Node2D

@onready var label_template = $Temp
var songlist

func _ready():
	
	songlist = $"..".song_list
	
	for i in 3:
		
		
		label_template.position.y = i * 150
		label_template.text = songlist[i]
		add_child(label_template.duplicate())
