extends Area2D

export var item_id = ""
export var item_name = ""
export var item_description = ""
export var item_path = ""

func _ready():
	pass

func _on_item_area_body_entered(body):
	if body.is_in_group("hero"):
		Global.on_item_area = true
		Global.current_item_path = item_path

func _on_item_area_body_exited(body):
	if body.is_in_group("hero"):
		Global.on_item_area = false
		Global.current_item_path = null

func _pick_item():
	Global.pick_item()

func _physics_process(delta):
	if Global.on_item_area and item_path == Global.current_item_path:
		if Input.is_action_just_pressed("ui_item_hold"):
			_pick_item()
