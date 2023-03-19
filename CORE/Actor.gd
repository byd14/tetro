class_name Actor
extends Node2D

@onready var Shape : CollisionShape = $CollisionShape

var velocity : Vector2 = Vector2.ZERO
var reminder : Vector2 = Vector2.ZERO
var platform : bool = false

func collision_move(offset : Vector2, time : float = 1) -> Vector2:
	var v_delta = offset * time
	reminder += v_delta
	v_delta = round(reminder)
	reminder -= v_delta

	var collision_x : bool = false; var collision_y : bool = true

	if v_delta.x != 0:
		if BACKYARD.collision_check(Shape, Shape.Overlaps, Vector2(v_delta.x, 0)):
			while !BACKYARD.collision_check(Shape, Shape.Overlaps, Vector2(sign(v_delta.x), 0)):
				global_position.x += sign(v_delta.x)
			v_delta.x = 0; reminder.x = 0;
			collision_x = true
		global_position.x += v_delta.x
	if v_delta.y != 0:
		if BACKYARD.collision_check(Shape, Shape.Overlaps, Vector2(0, v_delta.y)):
			while !BACKYARD.collision_check(Shape, Shape.Overlaps, Vector2(0, sign(v_delta.y))):
				global_position.y += sign(v_delta.y)
			v_delta.y = 0; reminder.y = 0
			collision_y = true
		if platform:
			var passenger : CollisionShape = BACKYARD.collision_check(Shape, ["Chara"], Vector2.UP)
			if passenger:
				global_position.y += v_delta.y
				passenger.get_parent().collision_move(Vector2(0, v_delta.y), 1)
				v_delta.y = 0
		global_position.y += v_delta.y
	
	return Vector2(!collision_x, !collision_y)