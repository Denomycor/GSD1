class_name Board
extends Node2D

onready var grid = $Grid
onready var helper = preload("res://source/Helper.gd")
onready var tags = preload("res://source/pieces/Tags.gd")

# NOTE: ALL MATRIX REPRESENTING THE BOARD ARE TRANSPOSED

var pieces
var subs
var format
const play_speed = 0.1

func _ready():
	$Timer.wait_time = play_speed
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
	
	var piece = add_piece(preload("res://source/pieces/Piece.tscn"), Vector2(5,8), 0, Vector2.UP)
	var piece2 = add_piece(preload("res://source/pieces/Piece.tscn"), Vector2(4,8), 0, Vector2.UP)
	var piece3 = add_piece(preload("res://source/pieces/Piece.tscn"), Vector2(3,8), 0, Vector2.UP)
	#var piece4 = add_piece(preload("res://source/pieces/Piece.tscn"), Vector2(5,8), 0, Vector2.UP)

	piece.add_tag_moving(10, Vector2.RIGHT)
	piece2.add_tag_moving(10, Vector2.RIGHT)
	piece3.add_tag_moving(10, Vector2.UP)
	#piece4.add_tag_moving(1, Vector2.DOWN)
	
	$Timer2.start() #temp
	yield($Timer2, "timeout")
	
	solve([piece3, piece2, piece], [])


func process_move(piece, move_list, next_list):
	var piece_eval_first = piece.check_other_piece_in_way(move_list)
	if piece_eval_first != null:
		move_list.remove(piece_eval_first[1])
		process_move(piece_eval_first[0], move_list, next_list)	
	# process one move eval
	# 1 - check if anyone affects you
	# 2 - check if you affect anyone
	# 3 - check if move still apllies
	if piece.tag_list.has(tags.MOVING):
		#todo remove tags uppon collision
		if piece.avaiable_move():
			pieces[piece.boardPos.x][piece.boardPos.y] = null
			piece.move()
			pieces[piece.boardPos.x][piece.boardPos.y] = piece
		else:
			piece.tag_list.erase(tags.MOVING)
		next_list.append(piece)
		


func solve(move_list, immediate_list):
	var next_list = []
	
	while move_list.size() != 0:
	
		while move_list.size() != 0 or immediate_list.size() != 0: # while there are changes to process
			if immediate_list.size() != 0:
				# process one immediate eval
				pass
			elif move_list.size() != 0:
				var piece = move_list.pop_front()
				process_move(piece, move_list, next_list)
		
		move_list = next_list
		next_list = []
		$Timer.start()
		yield($Timer, "timeout")
	
	print_debug("finished")


func init(format, matrix_sizes):
	self.format = format
	self.pieces = helper.create_null_matrix(matrix_sizes.x, matrix_sizes.y)
	self.subs = helper.create_null_matrix(matrix_sizes.x, matrix_sizes.y)


func add_piece(piece, boardPos, team, direction):
	piece = piece.instance()
	piece.init(boardPos, team, self, direction, play_speed) #etc
	pieces[boardPos.x][boardPos.y] = piece
	# ask to update subs table
	add_child(piece)
	return piece


func get_piece(coord):
	return pieces[coord.x][coord.y]


func empty_pos(pos):
	return format[pos.x][pos.y] == 'e' and pieces[pos.x][pos.y] == null
