extends Node2D

@onready var root = $".."
@onready var label_template = $Template

var weekList : Array
var weekMetadata : Dictionary

func _ready():
	
	pass

func make_list():
	
	weekList = root.weekList
	weekMetadata
	
	print(weekList.size())
	for i in weekList.size():
		
		var texture = ImageTexture.new()
		texture = load("res://Resources/Texture/Menus/Story Menu/weeks/" + root.weekList[i] + ".png")
		
		
		print(texture)
		label_template.position.y = i * 150
		label_template.texture = texture
		add_child(label_template.duplicate())
