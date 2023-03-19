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
	print(BACKYARD.collision_ray(Vector2(8, 8), Vector2(-1, -1)))

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

func complex_ray(origin : Vector2, dir : Vector2):
	for box in Shape:
		var wbox : Rect2i = get_box_world(box)
		var tmin : Vector2 = (Vector2(wbox.position) - origin) / dir
		var tmax : Vector2 = (Vector2(wbox.end) - origin) / dir
		var t1 : Vector2 = Vector2(min(tmin.x, tmax.x), min(tmin.y, tmax.y))
		var t2 : Vector2 = Vector2(max(tmax.x, tmin.x), max(tmax.y, tmin.y))
		var tnear : float = max(t1.x, t1.y)
		var tfar : float = min(t2.x, t2.y)
		if (tnear > tfar) or (tnear < 0  and tfar < 0): return false
		return Vector2(tnear, tfar)
