extends Node2D

var cam_focus = "Bf"
var cam_zoom = 1
var ui_zoom = 1

var filename = "blurt"

@export var cam_speed = 2.5
@export var default_cam_zoom = 0.8
@export var default_ui_zoom = 1
var bpm = 134
var last_beat = -1

@onready var camera = $Camera2D
@onready var ui_camera = $CanvasLayer/SubViewport/Camera2D
@onready var bpm_time = $Bpm
@onready var inst = $Songs/Inst
@onready var voices = $Songs/Voices

#@export var Bf : Node2D
#@export var Dad : Node2D

@onready var Bf = $BF
@onready var Dad = $Dad

func _ready():
	
	_find_and_set_song()
	
	
	
	cam_zoom = default_cam_zoom
	ui_zoom = default_ui_zoom
	#if not inst.stream.bpm == null:
		#bpm = inst.stream.bpm - 16
	
	

func _find_and_set_song():
	var inst_path = "res://Resources/Music/Songs/" + "blurt" + "/Inst.ogg"
	var voices_path = "res://Resources/Music/Songs/" + filename + "/Voices.ogg"
	var file_inst = FileAccess.open(inst_path, FileAccess.READ)
	var file_voices = FileAccess.open(voices_path, FileAccess.READ)
	
	#inst.stream = file_inst
	#voices.stream = file_voices
	
	inst.play()
	voices.play()

func _process(delta):
	
	
	var current_time = inst.get_playback_position()
	
	
		
	
	var current_beat = round(current_time / ((bpm / 60)) * 4)
	
	

	if current_beat != last_beat:
		
		var four_beat = round(current_time / (bpm / 60))
		#if fmod() = 4
		
		# Trigger your beat-related action here
		cam_zoom = default_cam_zoom + 0.025
		

		print("Beat hit:", current_beat)
		
		$AudioStreamPlayer.play()
		
		last_beat = current_beat
	
		GameplayMannager._beat()
	cam_zoom = lerpf(cam_zoom, default_cam_zoom, delta * cam_speed)
	
	
	camera.zoom.x = cam_zoom
	camera.zoom.y = cam_zoom
	
	
	
	if Input.is_action_just_pressed("uiConfirm"):
		cam_zoom = 0.825
	
	#if Input.is_action_just_pressed("uiRight"):
		#cam_focus = "Bf"
	#if Input.is_action_just_pressed("uiLeft"):
		#cam_focus = "Dad"
	
	if cam_focus == "Bf":
		
		camera.position.x = lerp(camera.position.x, Bf.camera_pos.x, delta * cam_speed)
		camera.position.y = lerp(camera.position.y, Bf.camera_pos.y, delta * cam_speed)
	
	if cam_focus == "Dad":
		
		camera.position.x = lerp(camera.position.x, Dad.camera_pos.x, delta * cam_speed)
		camera.position.y = lerp(camera.position.y, Dad.camera_pos.y, delta * cam_speed)
