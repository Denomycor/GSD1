class_name StaticPiece
extends Position2D

enum Classes {ATTACK, UTILITY, RESOURCE, HQ, WALL, OTHER}
enum Elements {FIRE, WATER, EARTH, WIND, LIGHTNING, VOID}

export(int, "ATTACK"," UTILITY", "RESOURCE", "HQ", "WALL", "OTHER") var piece_class :int
export(int, "FIRE", "WATER", "EARTH", "WIND", "LIGHTNING", "VOID") var element :int

export var hp :int
export var cost : int
export var piece_name :String
export var descritpion :String
export var status :String

var board_pos :Vector2
var team :int


func _ready():
	pass
