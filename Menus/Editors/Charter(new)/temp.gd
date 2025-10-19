extends TextureRect

var selected = false
var default_modulate = Color.WHITE

func _ready():
	default_modulate = modulate

func _process(delta):
	if selected:
		modulate = Color.WHITE
	else:
		modulate = default_modulate

func _on_mouse_entered():
	selected = true
	$"..".grids_selected += 1


func _on_mouse_exited():
	selected = false
	$"..".grids_selected += -1
