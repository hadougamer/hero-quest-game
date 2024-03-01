extends Node2D

var open_door = false

func _on_area_body_entered(body):
	if body.is_in_group('hero'):
		if Global.has_key:
			open_door=true
			
func _physics_process(delta):
	if Input.is_action_just_released("ui_up") and open_door:
		$sprite.play("oppening")


func _on_sprite_animation_finished():
	if $sprite.animation == "oppening":
		Global.load_level(2)
