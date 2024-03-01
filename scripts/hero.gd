extends KinematicBody2D

# Propriedades do personagem
const GRAVITY = 800
const MOVE_SPEED = 200
const JUMP_FORCE = -350
const SHOOT_COOLDOWN = 0.3  # Tempo de cooldown em segundos

enum Weapons { GUN, AXE, BOOMERANG }
var cur_weapon = Weapons.BOOMERANG

var pre_bullet = preload("res://scenes/weapons/bullet.tscn")
var pre_axe = preload("res://scenes/weapons/axe.tscn")
var pre_boomerang = preload("res://scenes/weapons/boomerang.tscn")

# Vetor de movimento
var velocity = Vector2()
var flipped = false
var bullets_limit = 100
var can_shoot = true
var shoot_timer = 0.0
var walking = false

var side1_colliding = false
var side2_colliding = false

func _ready():
	# No own bullet collision
	set_collision_mask_bit(2, false)

func _physics_process(delta):	
	velocity.y += GRAVITY * delta
	$sprite.flip_h = flipped
		
	# Shoot
	if shoot_timer > 0.0:
		shoot_timer -= delta
		if shoot_timer <= 0.0:
			can_shoot = true
	
	if Input.is_action_pressed("ui_shoot"):
		shoot(flipped)
	
	if Input.is_action_just_pressed("ui_switch"):
		print("Switch weapon ...")
		switch_weapon()
	
	# Movement
	velocity.x = 0
	
	if self.walking:
		$sprite.play("walk")
	else:
		$sprite.play("idle")
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += MOVE_SPEED
		flipped = false
		walking = true
		
	if Input.is_action_pressed("ui_left"):
		velocity.x -= MOVE_SPEED
		flipped = true
		walking = true
		
	if Input.is_action_just_released("ui_left"):
		walking = false
	if Input.is_action_just_released("ui_right"):
		walking = false

	# Collistion Ray
	if flipped:
		$side_ray.cast_to.x = -40
		$diagonal_ray.cast_to.x = -21
	else:
		$side_ray.cast_to.x = 40
		$diagonal_ray.cast_to.x = 21

	if $side_ray.is_colliding():			
		if $side_ray.get_collider().is_in_group("items"):
			if Input.is_action_just_released("ui_item_hold"):
				$side_ray.get_collider().queue_free()

	# Apply the move
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Item
	if can_put_item() and Input.is_action_just_pressed("ui_item_leave"):
		if Global.current_item != null:
			Global.leave_item()
		
	# Jump
	if is_on_floor() and Input.is_action_pressed("ui_jump"):
		velocity.y = JUMP_FORCE * Global.jump_multiplier
		
	# Reseta o multiplicador de pulo
	if is_on_floor() and not Input.is_action_pressed("ui_jump"):
		Global.jump_multiplier = 1

func switch_weapon():
	var current_weapon_index = Weapons.values().find(cur_weapon)
	var next_weapon_index = (current_weapon_index + 1) % Weapons.values().size()
	cur_weapon = Weapons.values()[next_weapon_index]

# Shoot methods
func shoot(flipped):
	var num_bullets = get_tree().get_nodes_in_group('bullets').size()
	if num_bullets > bullets_limit:
		clean_bullets()
		
	if num_bullets <= bullets_limit and can_shoot:
		match cur_weapon:
			Weapons.GUN:
				self.shoot_gun(flipped)
			Weapons.AXE:
				self.shoot_axe(flipped)
			Weapons.BOOMERANG:
				if get_tree().get_nodes_in_group('boomerang').size() == 0:
					self.shoot_boomerang(flipped)

func shoot_gun(flipped):
	var bullet = pre_bullet.instance()
	bullet.global_position.y = self.global_position.y
	bullet.flipped = flipped		
	bullet.global_position.x = self.global_position.x
	
	self.get_parent().add_child(bullet)
	can_shoot = false
	shoot_timer = SHOOT_COOLDOWN

func shoot_axe(flipped):
	var axe = pre_axe.instance()
	axe.global_position.y = self.global_position.y - 20
	axe.flipped = flipped		
	axe.global_position.x = self.global_position.x
	
	self.get_parent().add_child(axe)
	can_shoot = false
	shoot_timer = SHOOT_COOLDOWN * 3

func shoot_boomerang(flipped):
	var boomerang = pre_boomerang.instance()
	boomerang.global_position = self.global_position
	boomerang.flipped = flipped
	
	self.get_parent().add_child(boomerang)
	can_shoot = false
	shoot_timer = SHOOT_COOLDOWN
		
func clean_bullets():
	for b in get_tree().get_nodes_in_group('bullets'):
		if (b.global_position.x < global_position.x - 1000) or (b.global_position.x > global_position.x + 1000):
			print("Cleaning bullets")
			b.queue_free()

# Use Item
func can_put_item():
	if not is_on_floor():
		return false
	
	if $side_ray.is_colliding():
		return false
		
	if not $diagonal_ray.is_colliding():
		return false
		
	return true

# Die methods
func die():
	clean_bullets()
	Global.reset_hero()
	Global.clean_enemies()
	
func _on_notifier_screen_exited():
	if Global.teleporting == false:
		die()
	else:
		Global.teleporting = false
