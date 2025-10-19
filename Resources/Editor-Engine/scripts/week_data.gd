extends Resource

class_name weekData

@export_subgroup("Week Data")

@export var week_image : Texture2D
##The description for the week. Yes, bbcode is supported
@export var week_desc : String


@export_subgroup("Song Data")

@export var tracks : Array[String]

@export_enum("easy", "normal", "hard") var dificulties : Array[String]

@export var song_colors : Array[Color]
