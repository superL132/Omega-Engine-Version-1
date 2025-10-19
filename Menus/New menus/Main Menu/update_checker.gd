extends Node2D

@export var api_address : String
@export var redirect_address : String
@export_file("*.json") var update_file_dir : String

@onready var versionControl = $"Version Control"
var httpsEngine

var current_version = null
var current_versionID = null

var your_version = null
var you_versionID = null

var responce

var popup_open = false

var update_req = false
func _ready():
	if Settings.preferences.updates:
		if MenuMannager.version_startup:
			httpsEngine = get_node("HTTPRequest")
			httpsEngine.request_completed.connect(_https_complete)
			print(httpsEngine.is_connected("request_completed", _https_complete))
			_request_data()
			MenuMannager.version_startup = false

func _create_files():
	pass

func _request_data():
	httpsEngine.request(api_address)
	
	
	print("process 1 works, now trying to get responce from url")

func _save_version_to_file(content):
	var file = FileAccess.open(update_file_dir, FileAccess.WRITE_READ)
	
	file.store_string(content)

func _https_complete(result, response_code, headers, body):
	
	_save_version_to_file(body.get_string_from_utf8())
	
	print("process 2 works, now trying to check current version")
	
	print("responded?", response_code)
	
	if not response_code == 404:
		if not response_code == 0:
			
			if ProjectSettings.get_setting("omega/is_mod"):
				if ProjectSettings.get_setting("omega/has_custom_update_link"):
					versionControl.warningLabel.text = "This mod has a [color=skyblue][u]custom update checker api[/u][/color]. It is recomended that you update to the latest version."
				else:
					versionControl.warningLabel.text = "The [u][color=orangered]Omega Engine[/color][/u] has been marked as a mod. This could posibly be a mistake. Please contact the [u][color=skyblue]Mod Creator[/color][/u] and let them know"
			else:
				versionControl.warningLabel.text = "The [u][color=orangered]Omega Engine[/color][/u] is [color=red]out dated[/color]. It comes highly recomended that [u][b]all[/b][/u] updates be applied for [color=lightgreen]bug fixes, new content, etc...[/color]"
			
			#var version_file = FileAccess.open("res://Data/online version.json", FileAccess.WRITE_READ)
			
			
			var json = JSON.new()
			json.parse(body.get_string_from_utf8())
			responce = json.get_data()
			
			#version_file.store_string(JSON.stringify(responce))
			print(responce)
			
			if responce == null:
				printerr("Responce is null")
			else:
				#$Label.text = str(responce)
				print(responce.currentVersion)
				current_version = responce.currentVersion
				_check_for_new_version()
	
	else:
		printerr("The set api is unresponsive, please change the address")

func _check_for_new_version():
	if !current_version == ProjectSettings.get_setting("omega/version"):
		print("update plz")
		#DataMannager._write_file("online version.json", "responce")
		popup_open = true
		versionControl.yourVersionLabel.text = "Engine Version : " + ProjectSettings.get_setting("omega/version")
		versionControl.newVersionLabel.text = "Current Version : " + current_version
		
		update_req = true
		
		versionControl._toggle(true)
	versionControl.newFeaturesListNode.newFeatures = responce.new
	versionControl.newFeaturesListNode._reload()

func _notification(what):
	
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if Settings.preferences.updates:
			if update_req:
				OS.shell_open(redirect_address)

func _process(delta):
	
	if popup_open:
		$"../..".can_control = false
		if Input.is_action_just_pressed("uiConfirm"):
			$"../..".can_control = true
			versionControl._toggle(false)
			popup_open = false
