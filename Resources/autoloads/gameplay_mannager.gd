extends Node

var needSave = false

func _ready():
	print_rich("[color=darkgray]--- Start Game ---[/color]")
	print_rich("[color=green]All 'GameMannager'Functions have been completed![/color]")

func _notification(what):
	
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_close_request()

func _close_request():
	if needSave:
		_prompt_save()
	else:
		_close()

func _prompt_save():
	var confirm = ConfirmationDialog.new()
	
	MouseMannager._set_cursor("default")
	confirm.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	confirm.popup_window = true
	confirm.transient = true
	confirm.exclusive = true
	confirm.dialog_text = "There is an unsaved file open!\nClosing would discard the unsaved file\nNB: We can't specify what needs saving so we can't save for you... Not yet...\nProceed?"
	confirm.ok_button_text = "CLOSE"
	
	confirm.confirmed.connect(_close)
	
	confirm.show()
	
	add_child(confirm)

func _close():
	get_tree().quit()

func _startup_song(songName : String):
	
	pass
