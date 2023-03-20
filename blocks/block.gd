@tool
class_name Block
extends Actor

enum BLK_State {FALL, REST}
var state : BLK_State = BLK_State.FALL

const FALL_SPEED : int = 80

var BlockTexture : Texture2D = preload("res://assets/block.png")
var BoxSpriteDict : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	for box in Collision.Shape:
		var temp : Sprite2D = Sprite2D.new()
		temp.texture = BlockTexture
		add_child(temp)
		temp.move_local_x(8 + box.position.x); temp.move_local_y(8 + box.position.y)
		BoxSpriteDict[box.position] = temp
	velocity.y = FALL_SPEED


func _physics_process(delta):
	if !Engine.is_editor_hint():
		match state:
			BLK_State.FALL:
				if BACKYARD.collision_check(Collision, Collision.Overlaps, Vector2.DOWN):
					go_to_rest()
				else:
					collision_move(velocity, delta)
			BLK_State.REST:
				pass

func go_to_rest():
	state = BLK_State.REST
	for box in Collision.Shape:
		var wbox_pos : Vector2i = Collision.get_box_world(box).position
		BACKYARD.BlockMap[wbox_pos] = self
		if !BACKYARD.LineCheckQueue.has(wbox_pos.y):
			BACKYARD.LineCheckQueue.append(wbox_pos.y)