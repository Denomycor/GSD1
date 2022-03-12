class_name TestPiece
extends "res://source/pieces/abstraction/Piece.gd"

const effect_ref := preload("res://source/effects/TestEffect.gd")
const pi_ref := preload("res://source/pieces/PieceInfo.gd")

func _init():
	effect = effect_ref.new()
	effect.init(self, 1)
	
	piece_info = pi_ref.new()
	piece_info.init(2, 2, 6, pi_ref.Types.ATTACK, pi_ref.Elements.FIRE, 75, "Test Piece", "null", "null", [], 2)

	priority = 1
