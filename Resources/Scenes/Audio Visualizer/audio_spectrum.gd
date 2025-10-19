@tool
extends Control

@onready
var spectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("Music"), 0)
@onready var color_rect = $Base/right/top/ColorRect

 

@onready var bottomRightArray = $Base/right/top.get_children()

@export var intensity = 1
#@export var square_amount : int = 16
#var last_square_amt = 0

var VU_COUNT = 16
const HEIGHT = 60
const FREQ_MAX = 11050.0
 
const MIN_DB = 60
 
# Called when the node enters the scene tree for the first time.
func _ready():
	#bottomLeftArray.reverse()
	#topLeftArray.reverse()
	#_make_rects()
	pass
 
func _make_rects():
	
	for i in 1:
		color_rect.position.x = i * 32
		$Base/right/top.add_child(color_rect.duplicate())
		
	var bottomRightArray = $Base/right/top.get_children()

func _make_rect_color(strength, rect):
	
	
	
	#rect.modulate = Color.from_hsv(57, 100, 100)
	rect.modulate = Color.from_hsv(strength * 0.0005, 1, 1, 0.5)

func _process(delta):
	
	#if ! last_square_amt == square_amount:
		#last_square_amt = square_amount
		#_make_rects()
	
	var prev_hz = 0
	for i in range(1,VU_COUNT+1):   
		var hz = i * FREQ_MAX / VU_COUNT;
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
		var energy = clamp((MIN_DB + linear_to_db(f.length()))/MIN_DB,0,1)
		var height = energy * HEIGHT
 
		prev_hz = hz
		
		#Invalid access of index '8' on a base object of type: 'Array[Node]'.
		#solved
		var bottomRightRect = bottomRightArray[i - 1]
		
		var tween = create_tween()
		
		tween.tween_property(bottomRightRect, "size", Vector2(bottomRightRect.size.x, height * intensity), 0.05)
		#_make_rect_color(bottomRightRect.size.y, bottomRightRect)
