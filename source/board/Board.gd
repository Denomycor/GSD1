class_name Board
extends Node2D

onready var grid := $Grid
onready var helper := preload("res://source/Helper.gd")
onready var tags := preload("res://source/pieces/Tags.gd")

# NOTE: ALL MATRIX REPRESENTING THE BOARD ARE TRANSPOSED

var pieces
var all_pieces := []
var subs
var format
var play_speed := 0.1*1
var piece_id_count := 0 # limit 9223372036854775807

func _ready():
	
	$Timer.wait_time = play_speed*1.0
	init([
	"wwwwwwwwwwww",
	"weeeeeeeeeew",
	"weeeeeeeeeew",
	"weeeeeeeeeew",
	"weeeeeeeeeew",
	"weeeeeeeeeew",
	"weeeeeeeeeew",
	"weeeeeeeeeew",
	"weeeeeeeeeew",
	"wwwwwwwwwwww",
	], Vector2(12, 10))

	var piece_scene := preload("res://source/pieces/testPiece/TestPiece.tscn")
	
	var piece = add_piece(piece_scene, Vector2(2,2), 0, Vector2.RIGHT)
	var piece2 = add_piece(piece_scene, Vector2(7,2), 0, Vector2.LEFT)
	#var piece3 = add_piece(piece_scene, Vector2(3,8), 0, Vector2.UP)
	#var piece4 = add_piece(piece_scene, Vector2(1,1), 0, Vector2.DOWN)
	
	piece.add_tag_moving(10, Vector2.RIGHT)
	piece2.add_tag_moving(10, Vector2.LEFT)
	#piece3.add_tag_moving(10, Vector2.UP)
	#piece4.add_tag_moving(10, Vector2.DOWN)
	
	#piece.add_tag_rotating(-PI/2)
	#piece2.add_tag_rotating(PI/2)
	#piece3.add_tag_rotating(-PI/2)
	
	$Timer2.start() #temp
	yield($Timer2, "timeout")
	
	solve([piece, piece2])
	
	$Timer2.start() #temp
	yield($Timer2, "timeout")


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
		
	# 2 - check if you affect anyone
	for p in piece.make_affected_pieces_list():
		if !p.already_affected.has(piece.id):
			var changes = piece.effect.process_effect(p)
			helper.append_piece_array_no_duplicates(queue, changes)
			p.already_affected.append(piece.id)


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
	
		for piece in all_pieces:
			piece.already_affected = []
		
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
	# ask to update subs table
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
