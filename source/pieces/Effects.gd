class_name Effects
extends Reference


static func insert_effect_in_order(container, effect):
	var helper := preload("res://source/Helper.gd")
	for i in range(container.size()):
		if effect.priority > container[i].priority:
			container.insert(i, effect)
			return
		elif effect.priority == container[i].priority and helper.vec_before(effect.source_piece.boardPos, container[i].source_piece.boardPos):
			container.insert(i, effect)
			return
	container.append(effect)



class ChargeEffect:
	extends Reference
	
	var source_piece
	var priority
	
	#returns pieces that changed state and need to be evaluated, [move_list, immediate_list]
	func process_effect(affected_pieces):
		pass #todo
