class_name TestBoard
extends "res://source/board/abstraction/Board.gd"


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
	var piece3 = add_piece(piece_scene, Vector2(4,9), 0, Vector2.UP)
	var piece4 = add_piece(piece_scene, Vector2(1,1), 0, Vector2.DOWN)
	var piece5 = add_piece(piece_scene, Vector2(6, 10), 0, Vector2.UP)
	
	piece.add_tag_moving(10, Vector2.RIGHT)
	piece2.add_tag_moving(10, Vector2.LEFT)
	piece3.add_tag_moving(10, Vector2.UP)
	piece4.add_tag_moving(10, Vector2.DOWN)
	piece5.add_tag_moving(10, Vector2.UP)
	
	#piece.add_tag_rotating(-PI/2)
	#piece2.add_tag_rotating(PI/2)
	#piece3.add_tag_rotating(-PI/2)
	piece4.add_tag_rotating(-PI/2)
	
	$Timer2.start() #temp
	yield($Timer2, "timeout")
	
	solve([piece, piece2, piece3, piece4, piece5])
	
	$Timer2.start() #temp
	yield($Timer2, "timeout")

