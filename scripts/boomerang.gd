extends KinematicBody2D

const RETURN_FORCE = 600
const THROW_FORCE = 600
const ROTATION_SPEED = 10

var velocity = Vector2()
var target_x = null
var flipped = false
var throwing = true
var throw_duration = 0.7
var throw_timer = 0.7

func _ready():
	pass # Replace with function body.

func _process(delta):
	
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
			velocity.x = -THROW_FORCE
		else:
			velocity.x = THROW_FORCE
	else:
		if Global.hero:
			var direction = (Global.hero.global_position - global_position).normalized()
			velocity = direction * RETURN_FORCE
		

	velocity = move_and_slide(velocity, Vector2.UP)


func _on_area_body_entered(body):
	if body.is_in_group("hero") and not throwing:
		queue_free()
