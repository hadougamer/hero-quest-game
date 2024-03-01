extends Node2D

export var enemy: String = 'random'

var selected_enemy_index = 0
var pre_enemy_scene = null

var enemies = [
	'res://scenes/enemies/bat.tscn',
	'res://scenes/enemies/wave.tscn',
	'res://scenes/enemies/patrol.tscn'
]

func _ready():
	pass

func has_child_of_group(group_name: String) -> bool:
	for i in range(self.get_child_count()):
		var child = self.get_child(i)
		if child.is_in_group(group_name):
			return true
	return false

func load_enemie():
	print("Load enemy... ")
	if enemy == 'random':
		selected_enemy_index = randi() % enemies.size()
		pre_enemy_scene = load(enemies[selected_enemy_index])
	else:
		pre_enemy_scene = load('res://scenes/enemies/'+ str(enemy) + '.tscn')

	var enemy_instance = pre_enemy_scene.instance()

	add_child(enemy_instance)

func _on_notifier_screen_entered():
	if not has_child_of_group("enemies"):
		load_enemie()
