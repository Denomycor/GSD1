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


func add_tag_moving(moves, direction):
	tag_list[tags.MOVING] = [moves, direction]
	return self


func add_tag_rotating(angle):
	tag_list[tags.ROTATING] = angle
	return self


func move():
	boardPos += tag_list[tags.MOVING][1]
	if tag_list[tags.MOVING][0] > 1:
		tag_list[tags.MOVING][0] -= 1
	else:
		tag_list.erase(tags.MOVING)
	$Tween.interpolate_property(self, "position", position, board.grid.map_to_world(boardPos), play_speed)
	$Tween.start()


func rotate2():
	var angle = tag_list[tags.ROTATING]
	direction = direction.rotated(angle)
	if tag_list.has(tags.MOVING):
		tag_list[tags.MOVING][1] = tag_list[tags.MOVING][1].rotated(angle)
	tag_list.erase(tags.ROTATING)
	
	$Tween.interpolate_property($Sprite, "rotation", $Sprite.rotation, $Sprite.rotation+angle, play_speed)
	$Tween.start()


func avaiable_move():
	return board.empty_pos(boardPos + tag_list[tags.MOVING][1])


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


func get_subscribed_pos():
	#must return positions in order, maybe not
	return [boardPos+direction]


func destroy():
	board.remove_child(self)
	queue_free()


func update_subs_table():
	var new_pos = get_subscribed_pos()
	
	# check if update is necessary, might not be needed
	var needs_update = true
	if new_pos.size() == last_sub_indexes.size():
		needs_update = false
		for i in range(new_pos.size()):
			if new_pos[i] != last_sub_indexes[i]:
				needs_update = true
				break
	
	if needs_update:
		
		# remove old subs
		for pos in last_sub_indexes:
			var cell = board.subs[pos.x][pos.y]
			for i in range(cell.size()):
				if cell[i].source_piece.id == id:
					cell.remove(i)
		
		# update last_sub_indexes
		last_sub_indexes = new_pos
		
		# new subs
		for pos in last_sub_indexes:
			board.subs[pos.x][pos.y].append(effect) # needs to be inserted in order


func collided():
	tag_list.erase(tags.MOVING)
	tag_list[tags.ACTIVABLE] = false # not in all contexts


static func has_piece_with_id(container, id):
	for piece in container:
		if piece.id == id:
			return true
	return false
