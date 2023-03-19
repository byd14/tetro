extends Actor

const SPEED = 120
const JUMP_HEIGHT = 56
const GRAVITY = 980
const FALL_GRAVITY = 1290
const ACCELERATION = SPEED * 20
const FRICTION = SPEED * 10

@onready var JUMP_VELOCITY = -sqrt(2 * GRAVITY * JUMP_HEIGHT)

var is_grounded : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var direction = Input.get_axis("input_left", "input_right")

	if BACKYARD.collision_check(Shape, Shape.Overlaps, Vector2.DOWN):
		is_grounded = true
	else:
		is_grounded = false

	if Input.is_action_just_pressed("input_jump"):
		if is_grounded: velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("input_jump"):
		if velocity.y < 0: velocity.y /= 2

	velocity.x = move_toward(velocity.x, direction * SPEED, (ACCELERATION if direction != 0 else FRICTION) * delta)
	velocity.y += get_gravity() * delta

	velocity *= collision_move(velocity, delta) 

func get_gravity() -> float:
	return (FALL_GRAVITY if velocity.y > 0 else GRAVITY)