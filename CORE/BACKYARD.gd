extends Node

func collision_check(querier : CollisionShape, types : Array[StringName] = ["Solid"], offset : Vector2i = Vector2i.ZERO):
	var vault : Array[CollisionShape] = []
	for i in types:
		vault.append_array(get_tree().get_nodes_in_group(i))
	vault.erase(querier)
	for shape in vault:
		if querier.complex_intersect(shape, offset):
			return shape
	return false