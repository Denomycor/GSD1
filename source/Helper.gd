extends Reference


static func create_matrix(x, y, value):
	var temp = []
	for i in range(y):
		temp.append(create_array(x, value))
	return temp


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
