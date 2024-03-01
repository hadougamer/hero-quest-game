extends Node2D

var level_num = 1
var timer = null

func _ready():
	Global.root = self
	Global.transition = $transition	
	Global.load_level(level_num)
		
func _process(delta):
	pass

