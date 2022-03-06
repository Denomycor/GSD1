class_name Piece
extends Position2D

var tag_list = {}
var team
var board
var direction
var boardPos
var play_speed
var effect
var id
var last_sub_indexes = []

onready var tags = preload("res://source/pieces/Tags.gd")
onready var effects = load("res://source/pieces/Effects.gd")


# Initialize all necessary variables
func init(boardPos, team, board, direction, play_speed, id):
	self.boardPos = boardPos
	self.position = board.grid.map_to_world(boardPos)
	self.team = team
	self.board = board
	self.direction = direction
	self.play_speed = play_speed
	self.id = id
	var correct = direction.rotated(PI/2)
	$Sprite.rotation = atan2(correct.y, correct.x)


# add tag moving
func add_tag_moving(moves, direction):
	tag_list[tags.MOVING] = [moves, direction]
	return self


# add rotating tag
func add_tag_rotating(angle):
	tag_list[tags.ROTATING] = angle
	return self


# move piece 1 cell and update moving state
func move():
	boardPos += tag_list[tags.MOVING][1]
	if tag_list[tags.MOVING][0] > 1:
		tag_list[tags.MOVING][0] -= 1
	else:
		tag_list.erase(tags.MOVING)
	$Tween.interpolate_property(self, "position", position, board.grid.map_to_world(boardPos), play_speed)
	$Tween.start()


# rotate cell and update rotating state
func rotate2():
	var angle = tag_list[tags.ROTATING]
	direction = direction.rotated(angle)
	if tag_list.has(tags.MOVING):
		tag_list[tags.MOVING][1] = tag_list[tags.MOVING][1].rotated(angle)
	tag_list.erase(tags.ROTATING)
	
	$Tween.interpolate_property($Sprite, "rotation", $Sprite.rotation, $Sprite.rotation+angle, play_speed)
	$Tween.start()


# checks if next position on movement is clear
func avaiable_move():
	return board.empty_pos(boardPos + tag_list[tags.MOVING][1])


# checks if to make one move, another piece's movement needs to be processed first
func check_other_piece_in_way(move_list):
	if tag_list.has(tags.MOVING):
		for i in range(move_list.size()):
			var piece = move_list[i]
			if piece.tag_list.has(tags.MOVING):
				
				# ill rotate before moving
				if tag_list.has(tags.ROTATING) and !piece.tag_list.has(tags.ROTATING):
					if piece.boardPos == boardPos + tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]) and piece.tag_list[tags.MOVING][1]*-1 != tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]):
						return [piece, i]
				# noone will rotate before moving
				elif !tag_list.has(tags.ROTATING) and !piece.tag_list.has(tags.ROTATING):
					if piece.boardPos == boardPos + tag_list[tags.MOVING][1] and piece.tag_list[tags.MOVING][1]*-1 != tag_list[tags.MOVING][1]:
						return [piece, i]
				# other will rotate before moving
				elif !tag_list.has(tags.ROTATING) and piece.tag_list.has(tags.ROTATING):
					if piece.boardPos == boardPos + tag_list[tags.MOVING][1] and piece.tag_list[tags.MOVING][1].rotated(piece.tag_list[tags.ROTATING])*-1 != tag_list[tags.MOVING][1]:
						return [piece, i]
				# both will rotate before moving
				elif tag_list.has(tags.ROTATING) and piece.tag_list.has(tags.ROTATING):
					if piece.boardPos == boardPos + tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]) and piece.tag_list[tags.MOVING][1].rotated(piece.tag_list[tags.ROTATING])*-1 != tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]):
						return [piece, i]
	return null


# returns positions for this piece effect
func get_subscribed_pos():
	#must return positions in order, maybe not
	return [boardPos+direction]


# destroys this piece
func destroy():
	board.remove_child(self)
	queue_free()


#updates subscriptions table
func update_subs_table():
	
	# check if update is necessary, might not be needed as subscriptions only depend on pos and rotation
	# so it will always be called on process_move
	
	# remove old subs
	for pos in last_sub_indexes:
		var cell_effects = board.subs[pos.x][pos.y]
		for i in range(cell_effects.size()):
			if cell_effects[i].source_piece.id == id:
				cell_effects.remove(i)
	
	# update last_sub_indexes
	last_sub_indexes = get_subscribed_pos()
	
	# new subs
	for pos in last_sub_indexes:
		board.subs[pos.x][pos.y].append(effect) # needs to be inserted in order based on priority and pos


# called when piece stops movement by collision
func collided():
	tag_list.erase(tags.MOVING)
	#tag_list[tags.ACTIVABLE] = false # not in all contexts



static func has_piece_with_id(container, id):
	for piece in container:
		if piece.id == id:
			return true
	return false
