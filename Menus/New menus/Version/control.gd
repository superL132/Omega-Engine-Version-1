extends Control

var newFeatures : Array = []


func _ready():
	
	_reload()

func _reload():
	
	_fix_arrays()
	_make_list()

func _fix_arrays():
	
	pass

func _make_list():
	
	var listTemplate = $Template
	
	for i in newFeatures.size():
		
		listTemplate.position.y = i * 20
		listTemplate.text = str("• ", newFeatures[i])
		
		add_child(listTemplate.duplicate())
		
		
