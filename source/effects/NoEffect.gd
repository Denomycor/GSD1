class_name NoEffect
extends "res://source/effects/Effects.gd"


#returns pieces that changed state and need to be evaluated, [move_list, next_list, immediate_list]
func process_effect(affected_piece):
	if source_piece.tag_list.has(tags.MOVING):
		print(String(source_piece.id)+" collision "+String(affected_piece.id))
	return [[],[],[]]
