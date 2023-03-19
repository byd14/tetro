@tool
class_name CollisionShape
extends Node2D

@export var Shape : Array[Rect2i] = [Rect2i(0,0,16,16)]
@export var ObjectType : StringName = "Solid"
@export var Overlaps : Array[StringName] = ["Solid", "Block"]
@export var DebugColor : Color = Color(Color.AQUA, 0.4)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if Engine.is_editor_hint():
		for box in Shape:
			draw_rect(box, DebugColor)
			draw_rect(box, DebugColor, false, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()
	pass
