class_name Helper
extends Reference

# creates a 3dmatrix of size xyz with value
static func create_matrix3(x, y, z, value):
	var temp = []
	for i in range(y):
		temp.append(create_matrix(z,x, value))
	return temp


# creates a matrix of size xy with value
static func create_matrix(x, y, value):
	var temp = []
	for i in range(y):
		temp.append(create_array(x, value))
	return temp


# creates an array of size x with value
static func create_array(x, value):
	var temp = []
	for i in range(x):
		temp.append(value)
	return temp	


# returns whether v1 comes before v2 if reading board from top to bottom, left to right
static func vec_before(v1, v2):
	if v1.y < v2.y:
		return true
	elif v1.y > v2.y:
		return false
	elif v1.x < v2.x:
		return true
	else:
		return false


# checks if container has piece with id
static func has_piece_with_id(container, id):
	for piece in container:
		if piece.id == id:
			return true
	return false


static func get_index_with_id(container, id):
	for i in range(container.size()):
		if container[i].id == id:
			return i


# adds pieces to array if they are not there yet
static func append_piece_array_no_duplicates(arr1, arr2):
	for e in arr2: 
		if !has_piece_with_id(arr1, e.id):
			arr1.append(e)


# inserts effects in array based on order to be processed
static func insert_effect_in_order(container, effect):
	for i in range(container.size()):
		if effect.priority > container[i].priority:
			container.insert(i, effect)
			return
		elif effect.priority == container[i].priority and vec_before(effect.source_piece.board_pos, container[i].source_piece.board_pos):
			container.insert(i, effect)
			return
	container.append(effect)
