class_name Tag
extends Reference
	
var _name setget ,get_name
	
func _init(name):
	self._name = name
	
func get_name():
	return _name



class Moving:
	extends Tag
	
	var moves :int
	var direction :Vector2
	
	func _init(moves :int, direction :Vector2).("MOVING"):
		self.moves = moves
		self.direction = direction


class Freezed:
	extends Tag
	
	var turns :int
	
	func _init(turns :int).("FREEZED"):
		self.turns = turns


class Activated:
	extends Tag
	
	var is_activated :bool
	
	func _init(is_activated :bool).("ACTIVATED"):
		self.is_activated = is_activated
