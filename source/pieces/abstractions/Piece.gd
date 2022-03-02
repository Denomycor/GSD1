class_name Piece
extends Position2D

# signals
signal piece_left_clicked
signal piece_right_clicked

# enums
enum Classes {ATTACK, UTILITY, RESOURCE, HQ, WALL, OTHER}
enum Elements {FIRE, WATER, EARTH, WIND, LIGHTNING, VOID, NONE}
enum Actions {MOVE, ROTATE, ACTIVATE, TOGGLE}
#enum Status_tags {MOVING} see later if enum is to be used or classes

# private const attributes
export var _name :String               # Name of the piece
export var _description :String        # Description of the piece
export var _max_hp :int                # Max, starting hp
export var _mobility :int              # Range of movement action
export var _team :int                  # Team of the piece
export var _cost :int                  # Cost to play the piece
export(Classes) var _class :int        # Class of the piece from Classes enum
export(Elements) var _element :int     # Element of the piece from Element enum
export var _action_points :int         # Nr of actions this piece can make per turn
export var _actions := []              # Actions this piece is allowed to do from Actions enum
export var _vision :int                # Vision around this piece

# public attributes
var status_tags := {}                  # Dictionary of tags of effects affecting the piece from Status enum
var board                              # Reference to the board

# private attributes
var _board_pos :Vector2                # Board position (independent from position on screen)
var _rotation :Vector2                 # Rotation of the piece
var _hp :int                           # Current hp
var _remaining_actions :int            # Remaining action points this turn

# onready vars
onready var sprite = $Sprite



# PRIVATE FUNCS-------------------------------------------------------------------------------------------------

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



# PUBLIC FUNCS--------------------------------------------------------------------------------------------------

# returns all position the piece can move to
func avaiable_moves():	
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
	if _rotation.x == 0:
		return [Vector2(1,0), Vector2(-1, 0)]
	elif _rotation.y == 0:
		return [Vector2(0,1), Vector2(0, -1)]
	else: 
		return []



# TAGS FUNCS----------------------------------------------------------------------------------------------------

# Tag moving
func moving():
	pass



# ABSTRACT FUNCS------------------------------------------------------------------------------------------------

# pure abstract, returns the subscribed positions for this piece in the form of [ [position, effect] ]
func _subscribed_positions():
	pass


# abstract, called the state of this piece is changed, call this function if you override it
func _state_changed():
	pass #TODO update subscriptions-table


# called at the start of each turn, call this function if you override it, returns pieces that changed their state
func _turn_started():
	_remaining_actions = _action_points


# called at the end of each turn, call this function if you override it, returns pieces that changed their state
func _turn_ended():
	pass


# called when the piece is destroyed, call this function if you override it
func _destroy():
	free()


# abstract, called when a piece is activated, returns the pieces that changed their state
func _activate():
	pass


# returns whether this piece dropped to 0 health or not (doesn't call _destroy by default)
func _take_damage(value :int) -> bool:
	pass 
