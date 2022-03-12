class_name PieceInfo
extends Reference

enum Elements {FIRE, WATER, EARTH, LIGHTNING, WIND, VOID, NONE}
enum Types {ATTACK, UTILITY, RESOURCE, HQ, WALL, OTHER}

var hp :int
var move_range :int
var sight_range :int
var type :int
var element :int
var cost :int
var name :String
var description :String
var texture :Texture
var keywords :Array
var action_points :int

func init(hp, move_range, sight_range, type, element, cost, name, descrition, texture, keywords, action_points):
	self.hp = hp
	self.move_range = move_range
	self.sight_range = sight_range
	self.type = type
	self.element = element
	self.cost = cost
	self.name = name
	self.description = description
	self.texture = texture
	self.keywords = keywords
	self.action_points = action_points
