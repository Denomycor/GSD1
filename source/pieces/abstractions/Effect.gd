class_name Effect
extends Reference

var source_piece

func _init(source_piece):
	self.source_piece = source_piece

# abstract, returns pieces that changed their state
func effect(affected_piece):
	pass
