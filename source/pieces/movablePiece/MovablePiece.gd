class_name MovablePiece
extends "res://source/pieces/staticPiece/StaticPiece.gd"

# export private const specs for each piece
export var _move :int setget ,get_move


#private funcs
func _ready():
	pass


func _adjacent_board_pos(pos :Vector2):
	return [Vector2(pos.x+1, pos.y),Vector2(pos.x-1, pos.y),Vector2(pos.x, pos.y+1),Vector2(pos.x, pos.y-1)]


# public funcs
func avaiable_move(board):
	var queue = [[_board_pos, _move]]
	var moves = [_board_pos]
	
	var current = queue.pop_front()
	while current != null:
		for adj in _adjacent_board_pos(current[0]):
			if board.is_valid_pos(adj) and !moves.has(adj) and current[1]>0: #TODO implement board_is_valid_pos
				queue.append([adj,current[1]-1])
				moves.append(adj)
				
	return moves


# abstract funcs
func _move_piece():
	pass


# getters
func get_move():
	return _move
