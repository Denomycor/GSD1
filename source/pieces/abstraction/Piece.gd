class_name Piece
extends Position2D

# constructor variables
var board_pos :Vector2
var direction :Vector2
var team :int
var id :int
var play_speed :float
var board #:Board

# other variables
var effect
var piece_info :PieceInfo
var priority :int

# state variables
var tag_list := {} 
var last_sub_indexes := []
var current_hp :int
var current_action_points :int
var already_affected := []

# scripts
const tags := preload("res://source/pieces/Tags.gd")
const helper := preload("res://source/Helper.gd")


# Initialize all necessary variables
func init(board_pos, team, board, direction, play_speed, id):
	
	self.board_pos = board_pos.round()
	self.position = board.grid.map_to_world(self.board_pos)
	self.team = team
	self.board = board
	self.direction = direction
	self.play_speed = play_speed
	self.id = id
	self.current_hp = piece_info.hp
	
	var correct = direction.rotated(PI/2)
	$Sprite.rotation = atan2(correct.y, correct.x)
	
	add_subs_table()


# add tag moving
# warning-ignore:shadowed_variable
func add_tag_moving(moves, direction):
	tag_list[tags.MOVING] = [moves, direction]


# add rotating tag
func add_tag_rotating(angle):
	tag_list[tags.ROTATING] = angle


# move piece 1 cell and update moving state
func move():
	board_pos += tag_list[tags.MOVING][1]
	if tag_list[tags.MOVING][0] > 1:
		tag_list[tags.MOVING][0] -= 1
	else:
		tag_list.erase(tags.MOVING)
	board_pos = board_pos.round()
	$Tween.interpolate_property(self, "position", position, board.grid.map_to_world(board_pos), play_speed)
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
	return board.empty_pos((board_pos + tag_list[tags.MOVING][1]).round())


# destroys this piece
func destroy():
	remove_subs_table()
	board.remove_child(self)
	queue_free()


# returns positions for this piece effect, must return positions in order
func get_subscribed_pos():
	pass


# makes the piece take damage
func take_damage(damage):
	current_hp -= damage


# called when piece stops movement by collision
func collided():
	tag_list.erase(tags.MOVING)


#updates subscriptions table
func update_subs_table():
	remove_subs_table()
	add_subs_table()


# removes its subscriptions from table
func remove_subs_table():
	for pos in last_sub_indexes:
		var cell_effects = board.subs[pos.x][pos.y]
		for i in range(cell_effects.size()):
			if cell_effects[i].source_piece.id == id:
				cell_effects.remove(i)
				break


# add its subscriptions to table
func add_subs_table():
	last_sub_indexes = get_subscribed_pos()
	for pos in last_sub_indexes:
		helper.insert_effect_in_order(board.subs[pos.x][pos.y], (effect)) # needs to be inserted in order based on priority and pos


# returns all pieces in position to suffer from effect, in the order they must be processed
func make_affected_pieces_list():
	var pos = get_subscribed_pos()
	var pieces_in_order = []
	for i in range(pos.size(), 0, -1):
		i=i-1
		var piece = board.get_piece(pos[i])
		if piece != null:
	
			var found = false
			for j in range(pieces_in_order.size()):
				if piece.priority >= pieces_in_order[j].priority:
					pieces_in_order.insert(j, piece)
					found = true
					break
	
			if !found:
				pieces_in_order.append(piece)
	
	return pieces_in_order


# checks if to make one move, another piece's movement needs to be processed first
func check_other_piece_in_way(move_list):
	if tag_list.has(tags.MOVING):
		for i in range(move_list.size()):
			var piece = move_list[i]
			if piece.tag_list.has(tags.MOVING):
				
				# ill rotate before moving
				if tag_list.has(tags.ROTATING) and !piece.tag_list.has(tags.ROTATING):
					if piece.board_pos == board_pos + tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]) and piece.tag_list[tags.MOVING][1]*-1 != tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]):
						return [piece, i]
				# noone will rotate before moving
				elif !tag_list.has(tags.ROTATING) and !piece.tag_list.has(tags.ROTATING):
					if piece.board_pos == board_pos + tag_list[tags.MOVING][1] and piece.tag_list[tags.MOVING][1]*-1 != tag_list[tags.MOVING][1]:
						return [piece, i]
				# other will rotate before moving
				elif !tag_list.has(tags.ROTATING) and piece.tag_list.has(tags.ROTATING):
					if piece.board_pos == board_pos + tag_list[tags.MOVING][1] and piece.tag_list[tags.MOVING][1].rotated(piece.tag_list[tags.ROTATING])*-1 != tag_list[tags.MOVING][1]:
						return [piece, i]
				# both will rotate before moving
				elif tag_list.has(tags.ROTATING) and piece.tag_list.has(tags.ROTATING):
					if piece.board_pos == board_pos + tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]) and piece.tag_list[tags.MOVING][1].rotated(piece.tag_list[tags.ROTATING])*-1 != tag_list[tags.MOVING][1].rotated(tag_list[tags.ROTATING]):
						return [piece, i]
	return null
