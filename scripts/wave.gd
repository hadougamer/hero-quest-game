extends KinematicBody2D

const MOVE_SPEED = 5000

var flipped = null
var limit_top = null
var limit_bottom = null
	
var velocity = Vector2()

var displacement = null
export var direction: String = 'left'

var up = true

func _ready():
	displacement = rand_range(100, 190)
		
	limit_top = global_position.y - displacement
	limit_bottom = global_position.y + displacement	
		
func _physics_process(delta):
	velocity.x = 0
	
	if up:
		velocity.y -= 500 * delta
	else:
		velocity.y += 500 * delta
		
	if global_position.y < limit_top or global_position.y > limit_bottom:
		velocity.y = -velocity.y

	if direction == "right":
		velocity.x += MOVE_SPEED * delta
		flipped = false
	elif direction == "left":
		velocity.x -= MOVE_SPEED * delta
		flipped = true
		
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_notifier_screen_exited():	
	if self.global_position.distance_to(Global.hero.global_position) > 1000:
		print("clean wave enemy")
		queue_free()
