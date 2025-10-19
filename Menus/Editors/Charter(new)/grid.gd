extends Node2D

@onready var root = $"../.."
@onready var template = $Temp

var grids_selected = 0

func _ready():
	
	_draw_grid()

func _draw_grid():
	
	var extra1 = 0
	
	
	if root.section == 0:
		for i2 in 16:
			template.position.y = (45 * 0.75) * i2 * 1
			extra1 += 1
			if extra1 > 2:
				extra1 = 1
			for i in 9:
				
				if _get_oddEven(i + extra1):
					template.modulate = Color.GRAY
				else:
					template.modulate = Color.LIGHT_GRAY
				
				template.position.x = (45 * 0.75) * i
				add_child(template.duplicate())
	
	#template.modulate = Color.GRAY
	#for i2 in 10:
		#template.position.y = (45 * 0.75) * i2 * 1
		#for i in 4:
			#template.position.x = (45 * 0.75) * i * 2 + (45 * 0.75)
			#add_child(template.duplicate())

func _get_oddEven(number):
	
	#true is even and false is odd
	var value
	
	if number == 0:
		value = true
	if number == 1:
		value = false
	if number == 2:
		value = true
	if number == 3:
		value = false
	if number == 4:
		value = true
	if number == 5:
		value = false
	if number == 6:
		value = true
	if number == 7:
		value = false
	if number == 8:
		value = true
	if number == 9:
		value = false
	if number == 10:
		value = true
	return value

func _process(delta):
	
	if grids_selected > 0:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			MouseMannager._set_cursor("grabbing")
		else:
			MouseMannager._set_cursor("pointer")
	else:
		MouseMannager._set_cursor("default_new")
