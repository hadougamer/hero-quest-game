extends Area2D

func _on_die_area_body_entered(body):
	if body.is_in_group("hero"):
		body.die()
