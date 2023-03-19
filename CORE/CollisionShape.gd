@tool
class_name CollisionShape
extends Node2D

@export var Shape : Array[Rect2i] = [Rect2i(0,0,16,16)]
@export var ObjectType : StringName = "Solid"
@export var Overlaps : Array[StringName] = ["Solid", "Block"]
@export var DebugColor : Color = Color(Color.AQUA, 0.4)

func _init():
	if !Engine.is_editor_hint():
		add_to_group(ObjectType)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(BACKYARD.collision_check(self, Overlaps))

func _draw():
	if Engine.is_editor_hint():
		for box in Shape:
			draw_rect(box, DebugColor)
			draw_rect(box, DebugColor, false, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()	

func get_box_world(box : Rect2i, offset : Vector2i = Vector2i.ZERO):
	return Rect2i(box.position + Vector2i(global_position) + offset, box.size)

func complex_intersect(other : CollisionShape, offset : Vector2i = Vector2i.ZERO):
	for box in Shape:
		for box_ in other.Shape:
			if get_box_world(box, offset).intersects(other.get_box_world(box_)):
				return true
	return false

func complex_point(point : Vector2i):
	pass

func complex_line(start : Vector2i, end : Vector2i):
	pass