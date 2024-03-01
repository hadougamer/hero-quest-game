extends Node2D

var timeLeft = 350

func _ready():
	Global.time_left = timeLeft
	Global.heroSpawn = $heroSpawn
	$cam.current = true
	$cam.limit_left=0
	
	set_horizontal_limit(4500)
	
	Global.audio_player = $AudioPlayer

func set_horizontal_limit(limit):
	$cam.limit_right=limit

func _process(delta):	
	if Global.hero:		
		$cam.position = Global.hero.position


func _on_AudioPlayer_finished():
	$AudioPlayer.play()
