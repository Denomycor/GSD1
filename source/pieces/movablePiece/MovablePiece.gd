class_name MovablePiece
extends "res://source/pieces/staticPiece/StaticPiece.gd"

export var _move :int setget ,get_move



func _ready():
	pass


func get_move():
	return _move
