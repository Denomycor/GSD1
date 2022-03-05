class_name Effects
extends Reference


class ChargeEffect:
	extends Reference
	
	var source_piece
	
	#returns pieces that changed state and need to be evaluated, [move_list, immediate_list]
	func process_effect(affected_pieces):
		pass #todo
