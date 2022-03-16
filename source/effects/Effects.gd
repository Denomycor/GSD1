class_name Effects
extends Reference

const tags := preload("res://source/pieces/Tags.gd")

var source_piece
var priority

func init(source_piece, priority):
	self.source_piece = source_piece
	self.priority = priority


#returns pieces that changed state and need to be evaluated
func _process_effect(affected_piece):
	pass #todo
