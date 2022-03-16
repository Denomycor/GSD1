class_name TestEffect
extends "res://source/effects/Effects.gd"


#returns pieces that changed state and need to be evaluated, []
func process_effect(affected_piece):
	if source_piece.tag_list.has(tags.MOVING):
		print(String(source_piece.id)+" collision "+String(affected_piece.id))
		affected_piece.add_tag_rotating(PI/2)
		#source_piece.tag_list.erase(tags.MOVING)
		#affected_piece.take_damage(10)
	return [affected_piece]
