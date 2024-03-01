extends KinematicBody2D

const GRAVITY = 800
const MOVE_SPEED = 40
var velocity = Vector2()

export var flipped:bool = false
var can_change_direction = true

func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	$sprite.flip_h = flipped
	
	if not flipped:
		velocity.x = MOVE_SPEED
		$path_ray.cast_to.x = 25
		$diagonal_path_ray.cast_to.x = 25
	else:
		velocity.x = -MOVE_SPEED
		$path_ray.cast_to.x = -25
		$diagonal_path_ray.cast_to.x = -25
	
	if can_change_direction and (is_on_wall() or is_on_border()):
		flipped = not flipped
		can_change_direction = false
	elif not is_on_wall():
		can_change_direction = true
				
	velocity = move_and_slide(velocity, Vector2.UP)

func is_on_border():
	return not $diagonal_path_ray.is_colliding()

func is_on_wall():
	return $path_ray.is_colliding()
