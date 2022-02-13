class_name StaticPiece
extends "res://source/pieces/boardWallPiece/BoardWallPiece.gd"

#signals
signal piece_clicked

# export private const specs for each piece
export var _cost :int setget ,get_cost
export var _piece_name :String setget ,get_piece_name
export var _description :String setget ,get_description
export var _hp :int setget ,get_hp

# public vars
var status := []
var current_hp :int

# onready vars
onready var sprite := $Sprite


# private funcs
func _ready():
	pass


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if sprite.get_rect().has_point(to_local(event.position)):
			emit_signal("piece_clicked", self)


# abstract funcs
func _destroy():
	pass


# getters
func get_cost():
	return _cost

func get_piece_name():
	return _piece_name

func get_description():
	return _description
	
func get_hp():
	return _hp	

