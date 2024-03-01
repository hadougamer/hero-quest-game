extends CanvasLayer

var seconds = 0

func _ready():
	print("Hud loaded")


func _process(delta):
	seconds += (delta/2)
	$"Control/time_text".text=str(Global.time_left - round(seconds))
