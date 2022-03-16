class_name Board
extends Node2D

onready var grid := $Grid

# NOTE: ALL MATRIX REPRESENTING THE BOARD ARE TRANSPOSED

# state variables
var pieces
var all_pieces := []
var subs
var piece_id_count := 0 # limit 9223372036854775807
var clean_already_affected := []

# other variables
var play_speed := 0.1*3

# constructor variables
var format

# script variables
const helper := preload("res://source/Helper.gd")
const tags := preload("res://source/pieces/Tags.gd")


# processes one piece from moves queue
func move_pieces(piece, move_queue, queue):
	var piece_eval_first = piece.check_other_piece_in_way(move_queue)
	if piece_eval_first != null:
		move_queue.remove(piece_eval_first[1])
		move_pieces(piece_eval_first[0], move_queue, queue)
	
	var already_added = false
	
	if piece.tag_list.has(tags.ROTATING):
		piece.rotate2()
		if !already_added:
			queue.append(piece)
			already_added = true
	
	if piece.tag_list.has(tags.MOVING):
		if piece.avaiable_move():
			pieces[piece.board_pos.x][piece.board_pos.y] = null
			piece.move()
			pieces[piece.board_pos.x][piece.board_pos.y] = piece
			
			if !already_added:
				queue.append(piece)
				already_added = true
			
		else:
			piece.collided()
			
	if already_added:
		piece.update_subs_table()


func process_changes(piece, queue):
	# 1 - check if anyone affects you
	for effect in subs[piece.board_pos.x][piece.board_pos.y]:
		if !piece.already_affected.has(effect.source_piece.id):
			var changes = effect.process_effect(piece)
			helper.append_piece_array_no_duplicates(queue, changes)
			piece.already_affected.append(effect.source_piece.id)
			if !helper.has_piece_with_id(clean_already_affected, piece.id):
				clean_already_affected.append(piece)
		
	# 2 - check if you affect anyone
	for p in piece.make_affected_pieces_list():
		if !p.already_affected.has(piece.id):
			var changes = piece.effect.process_effect(p)
			helper.append_piece_array_no_duplicates(queue, changes)
			p.already_affected.append(piece.id)
			if !helper.has_piece_with_id(clean_already_affected, p.id):
				clean_already_affected.append(p)


# Called to destroy all pieces with <1 health
func destroy_pieces():
	var i=0
	while i < all_pieces.size():
		var piece = all_pieces[i]
		if piece.current_hp < 1:
			pieces[piece.board_pos.x][piece.board_pos.y] = null
			all_pieces.remove(i)
			piece.destroy()
		else:
			i+=1


# algorithm for solving turns
func solve(queue):
	while queue.size() !=0:
	
		while queue.size() !=0: #there are changes to be processed
			var piece = queue.pop_front()
			process_changes(piece, queue)
	
		destroy_pieces()
	
		for piece in clean_already_affected:
			piece.already_affected = []
		clean_already_affected = []
		
		var move_queue = all_pieces.duplicate()
		while move_queue.size() != 0:
			var p = move_queue.pop_front()
			move_pieces(p, move_queue, queue)
		
		$Timer.start()
		yield($Timer, "timeout")
		print_debug("clock_tick")
	
	print_debug("finished")


# initializes board
func init(format, matrix_sizes):
	self.format = format
	self.pieces = helper.create_matrix(matrix_sizes.x, matrix_sizes.y, null)
	self.subs = helper.create_matrix3(matrix_sizes.x, matrix_sizes.y, 0, null)


# instanciates a piece in the board
func add_piece(piece, board_pos, team, direction):
	piece = piece.instance()
	piece.init(board_pos, team, self, direction, play_speed, piece_id_count) #etc
	pieces[board_pos.x][board_pos.y] = piece
	
	add_child(piece)
	piece_id_count += 1
	all_pieces.append(piece)
	return piece


# gets piece at given coordinates
func get_piece(coord):
	return pieces[coord.x][coord.y]


# gets whether the given pos is vacant or not
func empty_pos(pos):
	return format[pos.x][pos.y] == 'e' and pieces[pos.x][pos.y] == null
