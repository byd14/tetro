extends Node

const LINE_LENGTH : int = 10

var BlockMap : Dictionary
var LineCheckQueue : Array[int]

func _ready():
	pass

func collision_check(querier : CollisionShape, types : Array[StringName] = ["Solid"], offset : Vector2 = Vector2.ZERO):
	var vault : Array[CollisionShape] = []
	for i in types:
		vault.append_array(get_tree().get_nodes_in_group(i))
	vault.erase(querier)
	for col in vault:
		if querier.complex_intersect(col, offset):
			return col
	return false

func collision_point(point : Vector2, ignore : CollisionShape = null, types : Array[StringName] = ["Block"]):
	var vault : Array[CollisionShape] = []
	for i in types:
		vault.append_array(get_tree().get_nodes_in_group(i))
	vault.erase(ignore)
	for col in vault:
		if col.complex_point(point):
			return col
	return false

func collision_ray(origin : Vector2, dir : Vector2, ignore : CollisionShape = null, types : Array[StringName] = ["Solid"], return_point : bool = false):
	var vault : Array[CollisionShape] = []
	for i in types:
		vault.append_array(get_tree().get_nodes_in_group(i))
	vault.erase(ignore)
	var result : CollisionShape = null
	var nearest : float = 0
	for col in vault:
		var test = col.complex_ray(origin, dir.normalized())
		if test:
			if result == null:
				result = col
				nearest = test
			elif test < nearest:
				result = col
				nearest = test
	if !return_point:
		return result
	else: 
		return origin + dir.normalized() * nearest

func _physics_process(_delta):
	if !LineCheckQueue.is_empty():
		for line in LineCheckQueue:
			line_check(line)

func line_check(line : int):
	LineCheckQueue.erase(line)
	var line_full : bool = true
	for i in LINE_LENGTH:
		if !BlockMap.has(Vector2i(i * 16, line)):
			line_full = false
			break
	if line_full:
		line_clear(line)

func line_clear(line : int):
	for i in LINE_LENGTH:
		var current : Vector2i = Vector2i(i * 16, line)
		var local : Rect2i = Rect2i(Vector2i(current - Vector2i(BlockMap[current].global_position)), Vector2i(16, 16))
		BlockMap[current].BoxSpriteDict[local.position].queue_free()
		BlockMap[current].BoxSpriteDict.erase(local.position)
		BlockMap[current].Collision.Shape.erase(local)
		BlockMap.erase(current)
