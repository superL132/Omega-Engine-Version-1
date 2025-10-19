extends Node2D

var instance = false

func _process(delta):
	
	if get_tree().has_group("Song"):
		instance = true
