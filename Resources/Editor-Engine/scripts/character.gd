@tool
@icon("res://Resources/Editor-Engine/Icons/character.png")
extends Node2D

##The charater used for a chart
class_name Character


@export var animations : SpriteFrames
@export_enum("bf", "dad", "gf") var role = "bf"
@export var camera_position : Vector2

@export_group("Game Play")
@export_subgroup("Icon Settings")
@export var icon : Texture = preload("res://Resources/Texture/icons/play state/icon-face.png")
@export var icon_color : Color = Color("555555")


@onready var sprite = AnimatedSprite2D.new()
@onready var camera_mark = Marker2D.new()


func _ready():
	
	add_child(sprite)
	add_child(camera_mark)
	
	camera_mark.position = camera_position
	sprite.sprite_frames = animations

func _process(delta):
	
	if Engine.is_editor_hint():
		camera_mark.position = camera_position
		sprite.sprite_frames = animations
		
