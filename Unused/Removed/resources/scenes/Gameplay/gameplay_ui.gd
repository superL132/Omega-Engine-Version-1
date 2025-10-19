extends CanvasLayer

@onready var camera = $Camera2D
@onready var screen = $screen

var cam_zoom
var default_cam_zoom = 1
var cam_speed = 2.5


func _ready():
	
	cam_zoom = default_cam_zoom
	
	GameplayMannager.beat.connect(_beat)

func _process(delta):
	
	screen.scale.x = cam_zoom
	screen.scale.y = cam_zoom
	
	cam_zoom = lerpf(cam_zoom, default_cam_zoom, delta * cam_speed)
	_handle_arrows()
	

func _handle_arrows():
	
	if Input.is_action_just_pressed("down"):
		$SubViewport/player_arrows/down.play("hit")
		$SubViewport/player_arrows/down/AnimationPlayer.play("RESET")
		$SubViewport/player_arrows/down/AnimationPlayer.play("pressed")
	elif Input.is_action_just_released("down"):
		$SubViewport/player_arrows/down.play("idle")
		$SubViewport/player_arrows/down/AnimationPlayer.play("RESET")
	
	if Input.is_action_just_pressed("left"):
		$SubViewport/player_arrows/left.play("hit")
		$SubViewport/player_arrows/left/AnimationPlayer.play("RESET")
		$SubViewport/player_arrows/left/AnimationPlayer.play("pressed")
	elif Input.is_action_just_released("left"):
		$SubViewport/player_arrows/left.play("idle")
		$SubViewport/player_arrows/left/AnimationPlayer.play("RESET")
	
	if Input.is_action_just_pressed("right"):
		$SubViewport/player_arrows/right.play("hit")
		$SubViewport/player_arrows/right/AnimationPlayer.play("RESET")
		$SubViewport/player_arrows/right/AnimationPlayer.play("pressed")
	elif Input.is_action_just_released("right"):
		$SubViewport/player_arrows/right.play("idle")
		$SubViewport/player_arrows/right/AnimationPlayer.play("RESET")
	
	if Input.is_action_just_pressed("up"):
		$SubViewport/player_arrows/up.play("hit")
		$SubViewport/player_arrows/up/AnimationPlayer.play("RESET")
		$SubViewport/player_arrows/up/AnimationPlayer.play("pressed")
	elif Input.is_action_just_released("up"):
		$SubViewport/player_arrows/up.play("idle")
		$SubViewport/player_arrows/up/AnimationPlayer.play("RESET")

func _beat(beat_no : float):
	cam_zoom = default_cam_zoom + 0.025
