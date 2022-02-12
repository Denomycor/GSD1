class_name StaticPiece
extends Position2D

enum Classes {ATTACK, UTILITY, RESOURCE, HQ, WALL, OTHER}
enum Elements {FIRE, WATER, EARTH, WIND, LIGHTNING, VOID}

export var hp :int
export var status := []

export(int, "ATTACK"," UTILITY", "RESOURCE", "HQ", "WALL", "OTHER") var _piece_class :int setget ,get_piece_class
export(int, "FIRE", "WATER", "EARTH", "WIND", "LIGHTNING", "VOID") var _element :int setget ,get_element

export var _cost : int setget ,get_cost
export var _piece_name :String setget ,get_piece_name
export var _description :String setget ,get_description

var _board_pos :Vector2 setget ,get_board_pos
var _team :int setget ,get_team


func _ready():
	pass
	
	
	
	
	
	

func get_piece_class():
	return _piece_class

func get_element():
	return _element

func get_cost():
	return _cost

func get_piece_name():
	return _piece_name

func get_description():
	return _description

func get_board_pos():
	return _board_pos

func get_team():
	return _team
