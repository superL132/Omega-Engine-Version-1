@tool
extends Resource

class_name CharacterData


@export var name : String
@export_enum("Bf", "Dad", "Gf") var default_type = "Bf"

@export_category("Animation Data")
@export var twoIdle : bool

@export_group("Idle Animations")
##THIS IS AN IMPORTANT VARIABLE!!! Please put a value that will not return null
@export var idle : String
##Please, don't place anything here if you don't have 'twoIdle' enebled!!!
@export var idle2 : String

@export_group("Arrow Animations")
@export var left : String
@export var right : String
@export var up : String
@export var down : String
