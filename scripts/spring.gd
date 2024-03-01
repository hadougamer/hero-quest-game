extends KinematicBody2D

func _ready():
	pass

func _physics_process(delta):
	if Global.on_spring:		
		if $collider.position.y < 18:
			$collider.position.y += (150 * delta)			
			
		Global.jump_multiplier += 0.05
			
	if not Global.on_spring:
		if $collider.position.y > 0:			
			$collider.position.y -= (150 * delta)
						
func _on_area_top_body_entered(body):
	if body.is_in_group("hero"):
		$sprite.play("down")
		Global.on_spring = true


func _on_area_top_body_exited(body):
	if body.is_in_group("hero"):
		$sprite.play("up")
		Global.on_spring = false
