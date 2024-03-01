extends Node

var root = null

# Hero item control
var has_key = false
var on_item_area = false
var current_item_path = null
var current_item = null

# Environment
var transition  = null
var audio_player  = null

var teleporting  = false
var num_level  = null
var cur_level = null # Current level
var time_left = 0
var on_spring = false
var jump_multiplier = 1

var heroSpawn = null
var hero = null
var hud = null
var main_scene = null
var pre_hud = preload("res://scenes/ui/hud.tscn")
var pre_hero = preload("res://scenes/hero.tscn")
var levels = [
	preload("res://scenes/levels/level1.tscn"),
	preload("res://scenes/levels/level2.tscn"),
]

var pre_fall_pf = preload("res://scenes/elements/falling_platform.tscn")

func _ready():
	pass

func load_hud(target):
	hud = pre_hud.instance()
	target.add_child(hud)

func load_level(num, timeLeft=500):
	# Cleanup the level
	for level in get_tree().get_nodes_in_group("levels"):
		level.queue_free()
		
	if transition:
		num_level = num
		cur_level = levels[(num-1)].instance()
		cur_level.timeLeft=timeLeft
		transition.load_level(root, cur_level)

func clean_enemies():
	print("Clean enemies... ")

	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.queue_free()

func reset_hero():
	for hero in get_tree().get_nodes_in_group("hero"):
		hero.queue_free()
	
	hero = pre_hero.instance()
	
	hero.global_position = heroSpawn.global_position
		
	heroSpawn.get_parent().add_child(hero)

func pick_item():		
	var item = load(current_item_path).instance()
	if current_item != null and current_item.get_name() != item.get_name():
		leave_item()
		
	current_item = item
	
func leave_item():
	current_item.position = hero.position
	
	if hero.flipped:
		current_item.position.x -= 32
	else:
		current_item.position.x += 32

	hero.get_parent().add_child(current_item)
	
	current_item = null
	
func _process(delta):
	if current_item and current_item.name == 'key':
		has_key = true
	else:
		has_key = false
