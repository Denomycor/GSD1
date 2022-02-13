class_name RotatablePiece
extends "res://source/pieces/movablePiece/MovablePiece.gd"

# enums
enum Rotation{UP, DOWN, LEFT, RIGHT}

# private vars
var _rotation :int setget ,get_rotation


# private funcs
func _ready():
	pass


# abstract functions
func _rotate():
	pass


# getters
func get_rotation():
	return _rotation
