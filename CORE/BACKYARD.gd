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

func collision_ray(origin : Vector2, dir : Vector2, ignore : CollisionShape = null, types : Array[StringName] = ["Solid"]):
	var vault : Array[CollisionShape] = []
	for i in types:
		vault.append_array(get_tree().get_nodes_in_group(i))
	vault.erase(ignore)
	for col in vault:
		var test = col.complex_ray(origin, dir.normalized())
		if test:
			return test
	return false

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
#		print(BlockMap)

func line_clear(line : int):
	for i in LINE_LENGTH:
		var block : Block = BlockMap[Vector2i(i * 16, line)]
		for box in block.Collision.Shape:
			if (block.Collision.get_box_world(box).position == Vector2i(i * 16, line)) :
				BlockMap.erase(Vector2i(i * 16, line))
				block.BoxSpriteDict[box.position].queue_free()
				block.Collision.Shape.erase(box)
				block.BoxSpriteDict.erase(box.position)
				if block.Collision.Shape.is_empty():
					block.queue_free()
			else:
				print(block.Collision.get_box_world(box).position)
