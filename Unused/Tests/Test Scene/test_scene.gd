extends Node2D

var label_node = Label.new()
var sprite_node = Sprite2D.new()
var preloadLabel = preload("res://Unused/Test Scene/new_label_settings.tres")
var preloadBgDesat = preload("res://Resources/Texture/Menus/Bgs/menuDesat.png")

func _ready():
	var index = 0
	
	sprite_node.texture = preloadBgDesat
	sprite_node.centered = false
	add_child(sprite_node)
	
	for i in 10:
		
		label_node.label_settings = preloadLabel
		label_node.position.y = i * 30
		print(i, ", ", label_node.position)
		
		label_node.text = str("bruh ", i)
		
		add_child(label_node.duplicate())
