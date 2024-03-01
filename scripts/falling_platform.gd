extends KinematicBody2D

var fall_velocity = 0
var velocity = Vector2()
var start_pos = null

func _ready():
	start_pos = global_position
	
func _physics_process(delta):
	velocity.y += fall_velocity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_area1_body_entered(body):
	if body.is_in_group("hero"):
		fall_velocity = 400

func _on_area2_body_entered(body):
	if not body.is_in_group("hero"):
		#$sprite.play("crashing")
		pass

func _on_sprite_animation_finished():
	if $sprite.animation == "crashing":		
		$collider.disabled = true
		$area1.get_child(0).disabled = true
		$area2.get_child(0).disabled = true
		$sprite.play("empty")
		
		$Timer.wait_time = 1.0
		$Timer.start()
		$Timer.connect("timeout", self, "_on_delay_timeout")
		
		
func _on_delay_timeout():
	var pf = Global.pre_fall_pf.instance()
	pf.global_position = start_pos
	get_parent().add_child(pf)
	
	queue_free()
