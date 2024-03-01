extends CanvasLayer

var target = null
var level = null

func load_level(_target, _level):
	target = _target
	level = _level
	
	$anim.play("fade_out")


func _on_anim_animation_finished(name):
	if name == "fade_out" and target != null and level != null:
		target.add_child(level)
		
		Global.load_hud(self)	
		Global.reset_hero()
		#Global.audio_player.play()
		
		$anim.play("fade_in")
		
func fade_in_out(duration: float):
	$anim.play("fade_out")
	$FadeTimer.wait_time = duration
	$FadeTimer.start()


func _on_FadeTimer_timeout():
	$anim.play("fade_in")
	$FadeTimer.stop()
