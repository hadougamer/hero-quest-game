extends KinematicBody2D

const MOVE_SPEED = 450
var velocity_bullet = Vector2()
var flipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.flip_h = self.flipped

func _process(delta):
	velocity_bullet.y = 0
	velocity_bullet.x = 0
	if flipped:
		velocity_bullet.x -= MOVE_SPEED
	else:
		velocity_bullet.x += MOVE_SPEED
	
	velocity_bullet = move_and_slide(velocity_bullet, Vector2.UP)


func _on_notifier_screen_exited():
	queue_free()
