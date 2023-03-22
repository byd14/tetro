class_name Tetro
extends Actor

enum TTR_State {IDLE, HOOK}
var state : TTR_State = TTR_State.IDLE

const SPEED : int = 120
const JUMP_HEIGHT : int = 56
const GRAVITY : int = 980
const FALL_GRAVITY : int = 1290
const ACCELERATION : int = SPEED * 20
const FRICTION : int = SPEED * 10
const HOOK_CONTRACTION : int = 12

@onready var JUMP_VELOCITY : float = -sqrt(2 * GRAVITY * JUMP_HEIGHT)
@onready var image : Sprite2D = $Sprite2D

var is_grounded : bool
var target : Vector2
var block_load : Block = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var direction : float = Input.get_axis("input_left", "input_right")
	var mouse_loc : Vector2 = get_viewport().get_mouse_position()

	if BACKYARD.collision_check(Collision, Collision.Overlaps, Vector2.DOWN):
		is_grounded = true
	else:
		is_grounded = false
	
	if Input.is_action_just_pressed("input_test"):
		if block_load:
			block_load.rotate_block(false)
	if Input.is_action_just_pressed("input_test2"):
		if block_load:
			block_load.rotate_block(true)
			
	if Input.is_action_just_pressed("input_action"):
		if block_load:
			throw(mouse_loc)
		else:
			hook(mouse_loc)
	if Input.is_action_just_pressed("input_jump"):
		jump()
	if Input.is_action_just_released("input_jump"):
		if velocity.y < 0: velocity.y /= 2

	match state:
		TTR_State.IDLE:
			target = mouse_loc
			velocity.x = move_toward(velocity.x, direction * SPEED, (ACCELERATION if direction != 0 else FRICTION) * delta)
			velocity.y += get_gravity() * delta
		TTR_State.HOOK:
			velocity = (target - (global_position + Vector2(8, 8))) * HOOK_CONTRACTION
			var reach = BACKYARD.collision_check(Collision, ["Block"], velocity.normalized() * 8)
			if reach:
				print(reach)
				state = TTR_State.IDLE
				block_load.freeze(false)
				block_load = reach.get_parent()
				block_load.follow(self)
		
	image.flip_h = target.x < global_position.x + 8

	velocity *= collision_move(velocity, delta) 

func get_gravity() -> float:
	return (FALL_GRAVITY if velocity.y > 0 else GRAVITY)

func jump(strength : float = JUMP_VELOCITY):
	if is_grounded && state == TTR_State.IDLE: velocity.y = strength

func hook(point : Vector2):
	var block = BACKYARD.collision_point(point)
	if block:
		var tetro_centre : Vector2 = global_position + Vector2(8, 8)
		var ray = BACKYARD.collision_ray(tetro_centre, point - tetro_centre, null, Collision.Overlaps)
		if ray && ray.get_parent():
			if ray.get_parent() == block.get_parent():
				print("hook")
				block_load = ray.get_parent() as Block
				block_load.freeze()
				state = TTR_State.HOOK
				target = BACKYARD.collision_ray(tetro_centre, point - tetro_centre, null, ["Block"], true)

func throw(point : Vector2):
	print("throw")