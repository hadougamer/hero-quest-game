extends KinematicBody2D

var ini_pos = null
var limit_left = null
var limit_right = null

var displacement = 200
var patrol_speed = 200
var chase_speed = 150

var velocity = null
var return_velocity = Vector2.ZERO

enum Modes { PATROL, CHASE, RETURN }

var returning = false
var current_mode = Modes.PATROL

var hero_distance = null
var chase_distance = 100

func _ready():
	ini_pos = global_position
	reset_bat()

func reset_bat():
	self.velocity = Vector2(patrol_speed, 0)
	
	limit_left = ini_pos.x - displacement
	limit_right = ini_pos.x + displacement
			
	global_position.x = ini_pos.x
	global_position.y = ini_pos.y
			
	self.returning = false
	current_mode = Modes.PATROL
	
func get_hero_distance():
	if Global.hero:
		return self.global_position.distance_to(Global.hero.global_position)

func patrol_mode():
	var collision = move_and_slide(self.velocity)
		
	if global_position.x < limit_left or global_position.x > limit_right:
		velocity.x = -velocity.x
		
	if self.hero_distance < self.chase_distance:
		current_mode = Modes.CHASE

		
func chase_mode():
	if Global.hero:
		var direction = (Global.hero.global_position - global_position).normalized()
		velocity = direction * chase_speed
		move_and_slide(velocity)
	
	if self.hero_distance > self.chase_distance:
		current_mode = Modes.RETURN

func return_mode():
	self.returning = true
	
	return_velocity = (ini_pos - global_position).normalized() * patrol_speed
	move_and_slide(return_velocity)
	
	if global_position.distance_to(ini_pos) < 3:
		reset_bat()

func _process(delta):
	self.hero_distance = get_hero_distance()

	match current_mode:
		Modes.PATROL:
			if not self.returning:
				patrol_mode()
		Modes.CHASE:
			if not self.returning:
				chase_mode()
		Modes.RETURN:
			return_mode()
