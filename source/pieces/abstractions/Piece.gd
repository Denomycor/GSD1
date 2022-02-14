class_name Piece
extends Position2D

# signals
signal piece_left_clicked
signal piece_right_clicked

# enums
enum Classes {ATTACK, UTILITY, RESOURCE, HQ, WALL, OTEHR}
enum Elements {FIRE, WATER, EARTH, WIND, LIGHTNING, VOID, NONE}
enum Rotation {UP, RIGHT, DOWN, LEFT}
enum Status {MOVING, IMOVABLE}
enum Actions {MOVE, ROTATE, ACTIVATE, TOGGLE}

# private const attributes
export var _name :String               # Name of the piece
export var _description :String        # Description of the piece
export var _max_hp :int                # Max, starting hp
export var _mobility :int              # Range of movement action
export var _team :int                  # Team of the piece
export var _cost :int                  # Cost to play the piece
export(Classes) var _class :int        # Class of the piece from Classes enum
export(Elements) var _element :int     # Element of the piece from Element enum
export var _priority :int              # Priority of this piece effects over other piece effects
var _action_points :int                # Nr of actions this piece can make per turn
var _actions := []                     # Actions this piece is allowed to do from Actions enum

# public attributes
var status := []                       # Tags of effects affecting the piece from Status enum

# private attributes
var _board_pos :Vector2                # Board position (independent from position on screen)
var _rotation :int                     # Rotation from Rotation enum
var _hp :int                           # Current hp
var _remaining_actions                 # Remaining action points this turn

# onready vars
onready var sprite = $Sprite

# ready func
func _ready():
	pass

# get locations adjacent to a given position 
func _adjacent_board_locations(pos):
	return [Vector2(pos.x+1, pos.y), Vector2(pos.x-1, pos.y), Vector2(pos.x, pos.y+1), Vector2(pos.x, pos.y-1)]


# handle input	
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if sprite.get_rect().has_point(to_local(event.position)):
			emit_signal("piece_left_clicked", self)
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		if sprite.get_rect().has_point(to_local(event.position)):
			emit_signal("piece_right_clicked", self)


# returns all position the piece can move to
func avaiable_moves(board):	
	var queue = [[_board_pos, _mobility]]
	var moves = [_board_pos]
	
	var current = queue.pop_front()
	
	while current != null:
		for adj in _adjacent_board_locations(current[0]):
			if board.is_valid_location(adj) and !moves.has(adj) and current[1] > 0:
				queue.append([adj, current[1]-1])
				moves.append(adj)
		current = queue.pop_front()
	
	moves.erase(_board_pos)
	return moves


# return all avaiable rotations the piece can make this turn
func avaiable_rotations():
	return [(_rotation+1) % Rotation.size(), (_rotation-1) % Rotation.size()]


# abstract, returns all the positions this piece's passive effect influences
func _passive_subscribed_positions():
	pass


# abstract, updates the state of multiple pieces according to his passive effect
func _passive_effect(affected_pieces):
	pass


# abstract, returns all the positions this piece's active effect influences
func _active_subscribed_positions():
	pass


# abstract, updates the state of multiple pieces according to his active effect
func _active_effect(affected_pieces):
	pass


# abstract, function called when the piece is activated, must yield for every state it reaches
func _activate():
	pass


# called at the start of each turn
func turn_started():
	_remaining_actions = _action_points


# called at the end of each turn
func turn_ended():
	pass


# called when the piece is destroyed
func destroy():
	free()
