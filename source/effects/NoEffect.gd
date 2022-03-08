class_name NoEffect
extends "res://source/effects/Effects.gd"


#returns pieces that changed state and need to be evaluated, [move_list, next_list, immediate_list]
func _process_effect(affected_pieces):
	return [[],[],[]]
