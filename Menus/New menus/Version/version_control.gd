extends Control

#the link
#https://gist.githubusercontent.com/superL132/f96d54a10ae3b944b65d378344c32acc/raw/version_control.json

#formula
#https://gist.github.com/<USER_NAME>/<GIST_ID>/raw/<GIST_FILE_NAME>

#and finally, don't forget the cat in the bathroom, lol

@onready var newFeaturesListNode = $"Panel/New Features List"
@onready var warningLabel = $"Panel/Warning label"
@onready var yourVersionLabel = $"Panel/Your version"
@onready var newVersionLabel = $"Panel/new version"


func _toggle(toggle : bool):
	if toggle:
		$AnimationPlayer.play("open")
	else:
		$AnimationPlayer.play_backwards("open")
	
