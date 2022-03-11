class_name NoEffect
extends "res://source/effects/Effects.gd"


#returns pieces that changed state and need to be evaluated, []
func process_effect(affected_piece):
	if source_piece.tag_list.has(tags.MOVING):
		print(String(source_piece.id)+" collision "+String(affected_piece.id))
		#source_piece.tag_list.erase(tags.MOVING)
		affected_piece.add_tag_rotating(PI/2)
	return []
