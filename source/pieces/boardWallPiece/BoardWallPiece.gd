class_name BoardWallPiece
extends Position2D

# enums 
enum Classes {ATTACK, UTILITY, RESOURCE, HQ, WALL, OTHER}
enum Elements {FIRE, WATER, EARTH, WIND, LIGHTNING, VOID}

# export private const specs for each piece
export(Classes) var _piece_class :int setget ,get_piece_class
export(Elements) var _element :int setget ,get_element


# private vars
var _board_pos :Vector2 setget ,get_board_pos
var _team :int setget ,get_team


# private funcs
func _ready():
	pass


# getters	
func get_piece_class():
	return _piece_class

func get_element():
	return _element
	
func get_board_pos():
	return _board_pos

func get_team():
	return _team
