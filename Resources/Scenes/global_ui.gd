extends CanvasLayer

var fps = 0

func _process(delta):
	
	fps = lerpf(fps, Engine.get_frames_per_second(), delta * 10)
	
	$Panel/FPS.text = str("FPS : ", snapped(fps, 1))
	$Panel/Memory.text = str("RAM : ", OS.get_static_memory_usage() / 1000000, "MB")
	
	if Settings.preferences.shaders:
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false
	
	$Panel/status.text = ""
