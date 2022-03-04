class_name Piece
extends Position2D

var tag_list = {}
var team
var board
var direction
var boardPos
var play_speed

onready var tags = preload("res://source/pieces/Tags.gd")

func init(boardPos, team, board, direction, play_speed):
	self.boardPos = boardPos
	self.position = board.grid.map_to_world(boardPos)
	self.team = team
	self.board = board
	self.direction = direction
	self.play_speed = play_speed

func add_tag_moving(moves, direction):
	tag_list[tags.MOVING] = [moves, direction]
	return self

func move():
	boardPos += tag_list[tags.MOVING][1]
	if tag_list[tags.MOVING][0] > 1:
		tag_list[tags.MOVING][0] -= 1
	else:
		tag_list.erase(tags.MOVING)
	$MoveTween.interpolate_property(self, "position", position, board.grid.map_to_world(boardPos), play_speed)
	$MoveTween.start()


func avaiable_move():
	#if tag_list.has(tags.MOVING):
		#return true
	return board.empty_pos(boardPos + tag_list[tags.MOVING][1])


func check_other_piece_in_way(move_list):
	for i in range(move_list.size()):
		var piece = move_list[i]
		if piece.tag_list.has(tags.MOVING):
			if piece.boardPos == boardPos + tag_list[tags.MOVING][1] and piece.tag_list[tags.MOVING][1]*-1 != tag_list[tags.MOVING][1]:
				return [piece, i]
	return null
