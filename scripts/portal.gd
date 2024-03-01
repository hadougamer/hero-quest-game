extends Node2D

var _over_portal:bool = false
export var _target:String = ""

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("ui_up") and self._over_portal:
		if self._target != "":
			Global.teleporting = true
			var target_portal = get_parent().get_node(self._target)
			Global.hero.global_position = target_portal.global_position
			
			# Updates the Hero Spawn position
			Global.heroSpawn.global_position = global_position
			
func _on_area_body_entered(body):
	if body.is_in_group("hero"):
		print("over portal")
		self._over_portal = true

func _on_area_body_exited(body):
	if body.is_in_group("hero"):
		print("out portal")
		self._over_portal = false
