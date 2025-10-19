extends Label


@onready var icon = $TextureRect
@onready var root = $"../../.."

var id = 0

func _process(delta):
	
	if root.menu_option == id:
		position.x = lerpf(position.x, 300, delta * 7)
		modulate = Color("FFFFFF")
	else:
		position.x = lerpf(position.x, 150, delta * 7)
		modulate = Color("555555")
