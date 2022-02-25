
enum B_types {v,c,w,b}

#JSON string with board layout
var boardDescriptor = "[[v,c,c,c,c,v], [c,c,c,c,c,c],  [c,c,w,w,c,c], [c,c,c,c,c,c] [v,c,c,c,c,v]]"


# private variables
var _locked = false
var _board
var _event_board
var _pieces = []
class_name Board


# Called when the node enters the scene tree for the first time.
func _ready():
	_board = JSON.parse(boardDescriptor)
	if verify_board():
		print_debug("board parsed correctly")
	else:
		push_error("Cannot Mount Board, doesn't meet the required specification")

# Verifies the board is of consistent size and prepares _event_board to reieve actions
func verify_board():
	var leng = _board[0].size()
	for i in range(1, _board.size()):
		if _board[i].size() != leng:
			push_error("Cannot Mount Board, doesn't meet the required specification")
		else:
			_event_board[i] = []
			for j in range(0, leng):
				if _board[i][j] != B_types.v:
					_event_board[i][j] = []


#piece request to move
func request_move( piece ):
	if _pieces.has(piece) && !_locked:
		_locked = true
		exec_move(piece)
		_locked = false

# dont know if is needed
func exec_move( piece ):
	#TODO:
	pass

# subsribes an action
func subsribe_action( x, y, action ):
	if _board[x][y] != B_types.b && _board[x][y] != B_types.v:
		_event_board[x][y].append(action) 

# unsubsribes an action
func unsubsribe_action( x, y, action ):
	_event_board[x][y].erase(action)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
