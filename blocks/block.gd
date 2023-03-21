@tool
class_name Block
extends Actor

enum BLK_State {FALL, REST, FREEZE, FOLLOW}
var state : BLK_State = BLK_State.FALL

const FALL_SPEED : int = 80
const FOLLOW_CONTRACTION : int = 15

@onready var image_origin : Node2D = $image_origin

var BlockTexture : Texture2D = preload("res://assets/block.png")
var BoxSpriteDict : Dictionary
var reshape_queued : bool = false
var carry : Actor = null

# Called when the node enters the scene tree for the first time.
func _ready():
	platform = true
	for box in Collision.Shape:
		var temp : Sprite2D = Sprite2D.new()
		temp.texture = BlockTexture
		image_origin.add_child(temp)
		temp.move_local_x(8 + box.position.x); temp.move_local_y(8 + box.position.y)
		BoxSpriteDict[box.position] = temp
	velocity.y = FALL_SPEED


func _physics_process(delta):
	if !Engine.is_editor_hint():
		match state:
			BLK_State.FALL:
				if BACKYARD.collision_check(Collision, Collision.Overlaps, Vector2.DOWN):
					sleep()
				else:
					collision_move(velocity, delta)
			BLK_State.FOLLOW:
					velocity = ((carry.global_position + Vector2(8, -24)) - global_position) * FOLLOW_CONTRACTION
					velocity *= collision_move(velocity, delta)
			BLK_State.REST:
				if Collision.Shape.is_empty():
					queue_free()
				elif !BACKYARD.collision_check(Collision, Collision.Overlaps, Vector2.DOWN):
					wake()

func sleep():
	state = BLK_State.REST
	for box in Collision.Shape:
		var wbox_pos : Vector2i = Collision.get_box_world(box).position
		BACKYARD.BlockMap[wbox_pos] = self
		if !BACKYARD.LineCheckQueue.has(wbox_pos.y):
			BACKYARD.LineCheckQueue.append(wbox_pos.y)

func wake():
	state = BLK_State.FALL
	for box in Collision.Shape:
		var wbox_pos : Vector2i = Collision.get_box_world(box).position
		BACKYARD.BlockMap.erase(wbox_pos)

func freeze(new_freeze : bool = true):
	velocity = Vector2.ZERO
	if new_freeze:
		state = BLK_State.FREEZE
	else:
		state = BLK_State.FALL
		velocity.y = FALL_SPEED

func follow(new_carry : Actor):
	carry = new_carry
	Collision.remove_from_group(Collision.ObjectType)
	platform = false
	velocity = Vector2.ZERO
	state = BLK_State.FOLLOW