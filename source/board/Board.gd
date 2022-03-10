class_name Board
extends Node2D

onready var grid := $Grid
onready var helper := preload("res://source/Helper.gd")
onready var tags := preload("res://source/pieces/Tags.gd")

# NOTE: ALL MATRIX REPRESENTING THE BOARD ARE TRANSPOSED

var pieces
var subs
var format
const play_speed := 1
var piece_id_count := 0 # limit 9223372036854775807

func _ready():
	
	$Timer.wait_time = play_speed*10
	init([
	"weeeeeeeeeee",
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
	
	var piece_scene := preload("res://source/pieces/Piece.tscn")
	
	var piece = add_piece(piece_scene, Vector2(3,3), 0, Vector2.LEFT)
	var piece2 = add_piece(piece_scene, Vector2(1,3), 0, Vector2.RIGHT)
	#var piece3 = add_piece(piece_scene, Vector2(3,8), 0, Vector2.UP)
	#var piece4 = add_piece(piece_scene, Vector2(1,1), 0, Vector2.DOWN)

	piece.add_tag_moving(10, Vector2.LEFT)
	piece2.add_tag_moving(10, Vector2.RIGHT)
	#piece3.add_tag_moving(10, Vector2.UP)
	#piece4.add_tag_moving(10, Vector2.DOWN)
	
	#piece.add_tag_rotating(-PI/2)
	#piece2.add_tag_rotating(PI/2)
	#piece3.add_tag_rotating(-PI/2)
	
	$Timer2.start() #temp
	yield($Timer2, "timeout")
	
	solve([piece, piece2], [])
	
	$Timer2.start() #temp
	yield($Timer2, "timeout")


# processes one piece from moves queue
func process_move(piece, move_list, next_list, immediate_list):
	var piece_eval_first = piece.check_other_piece_in_way(move_list)
	if piece_eval_first != null: 
		move_list.remove(piece_eval_first[1])
		process_move(piece_eval_first[0], move_list, next_list, immediate_list)	
	
	process_effects(piece, move_list, next_list, immediate_list)
	
	var already_added = helper.has_piece_with_id(next_list, piece.id)
	
	if piece.tag_list.has(tags.ROTATING):
		piece.rotate2()
		if !already_added:
			next_list.append(piece)
			already_added = true
	
	if piece.tag_list.has(tags.MOVING):
		if piece.avaiable_move():
			pieces[piece.boardPos.x][piece.boardPos.y] = null
			piece.move()
			pieces[piece.boardPos.x][piece.boardPos.y] = piece
			
			if !already_added:
				next_list.append(piece)
				already_added = true
			
		else:
			piece.collided()
			
	if already_added:
		piece.update_subs_table()
	print("processed: "+String(piece.id))


func process_effects(piece, move_list, next_list, immediate_list):
	# 1 - check anyone affects you
	for effect in subs[piece.boardPos.x][piece.boardPos.y]:
		var changes = effect.process_effect(piece)
		helper.append_piece_array_no_duplicates(move_list, changes[0])
		helper.append_piece_array_no_duplicates(next_list, changes[1])
		helper.append_piece_array_no_duplicates(immediate_list, changes[2])
	
	# 2 - check if you affect anyone
	for p in piece.make_affected_pieces_list():
		var changes = piece.effect.process_effect(p)
		helper.append_piece_array_no_duplicates(move_list, changes[0])
		helper.append_piece_array_no_duplicates(next_list, changes[1])
		helper.append_piece_array_no_duplicates(immediate_list, changes[2])


# algorithm for solving turns
func solve(move_list, immediate_list):
	var next_list = []
	
	while move_list.size() != 0:
	
		while move_list.size() != 0 or immediate_list.size() != 0: # while there are changes to process
			if immediate_list.size() != 0:
				var piece = immediate_list.pop_front()
				process_effects(piece, move_list, next_list, immediate_list)
	
			elif move_list.size() != 0:
				var piece = move_list.pop_front()
				process_move(piece, move_list, next_list, immediate_list)
		
		move_list = next_list
		next_list = []
		yield()#temp
		$Timer.start()
		yield($Timer, "timeout")
		print("---------------------------------")
	
	print_debug("finished")


# initializes board
func init(format, matrix_sizes):
	self.format = format
	self.pieces = helper.create_matrix(matrix_sizes.x, matrix_sizes.y, null)
	self.subs = helper.create_matrix3(matrix_sizes.x, matrix_sizes.y, 0, null)


# instanciates a piece in the board
func add_piece(piece, boardPos, team, direction):
	piece = piece.instance()
	piece.init(boardPos, team, self, direction, play_speed, piece_id_count) #etc
	pieces[boardPos.x][boardPos.y] = piece
	# ask to update subs table
	add_child(piece)
	piece_id_count += 1
	return piece


# gets piece at given coordinates
func get_piece(coord):
	return pieces[coord.x][coord.y]


# gets whether the given pos is vacant or not
func empty_pos(pos):
	return format[pos.x][pos.y] == 'e' and pieces[pos.x][pos.y] == null
