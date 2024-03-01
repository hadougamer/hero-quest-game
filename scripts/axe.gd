extends KinematicBody2D

const GRAVITY = 1500
const THROW_FORCE = -500
const ROTATION_SPEED = 5

var velocity = Vector2()
var target_x = null
var flipped = false
var throwing = true
var throw_duration = 0.4
var throw_timer = 0.4

func _ready():
	pass

func _process(delta):
	if target_x:
		velocity.x = target_x

	velocity.y += GRAVITY * delta

	if throw_timer > 0.0:
		throw_timer -= delta
		if throw_timer <= 0.0:
			throwing = false

	if flipped:
		rotate(-ROTATION_SPEED * delta)
	else:
		rotate(ROTATION_SPEED * delta)

	if throwing:
		if flipped:
			velocity.x -= 4.5
		else:
			velocity.x += 4.5
		velocity.y = THROW_FORCE
	else:
		target_x = velocity.x

	velocity = move_and_slide(velocity, Vector2.UP)


func _on_area_body_entered(body):
	if not body.is_in_group("hero") and body != self:
		queue_free()
