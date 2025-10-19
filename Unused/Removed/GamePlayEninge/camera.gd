extends Camera2D

var focus
var camera_speed = 2.5


func _process(delta):
	
	if Input.is_key_pressed(KEY_E):
		focus = "bf"
	if Input.is_key_pressed(KEY_Q):
		focus = "dad"
	if Input.is_key_pressed(KEY_T):
		focus = "gf"
	if Input.is_key_pressed(KEY_R):
		focus = null
	
	if focus == "bf":
		position = lerp(position, $"../characters/Main/BF".camera_mark.global_position, delta * camera_speed)
	if focus == "dad":
		position = lerp(position, $"../characters/Main/Dad".camera_mark.global_position, delta * camera_speed)
	if focus == "gf":
		position = lerp(position, $"../characters/Back Characters/Gf".camera_mark.global_position, delta * camera_speed)
		
