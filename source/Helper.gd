extends Reference


static func create_null_matrix(x, y):
	var temp = []
	for i in range(y):
		temp.append(create_null_array(x))
	return temp


static func create_null_array(x):
	var temp = [null]
	temp.resize(x)
	return temp


static func vec_before(v1, v2):
	if v1.y < v2.y:
		return true
	elif v1.y > v2.y:
		return false
	elif v1.x < v2.x:
		return true
	else:
		return false
