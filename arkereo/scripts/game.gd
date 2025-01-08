extends Node2D

var difficulty_scale : int = 1
var enemy_health = 0
var enemy_speed = 0
var enemy_spawn_scale = 100
var spawn_rate = 0.0
#var perk_lvl = 0
#var perk_queue = false

@export var cam : Node
@export var spawner_container : Node

func _on_timer_timeout():
	# increment difficulty scale
	difficulty_scale += 1
	
	#perk_lvl += 1
	#if perk_lvl == 10:
		#perk_lvl = 0
		#perk_queue = true
	
	cam.update("difficulty", "Difficulty: " + str(difficulty_scale))
	
	# adjust enemy stats
	enemy_health += 20
	enemy_speed += 20
	enemy_spawn_scale -= 2
	# increase enemy spawnrate
	for i in spawner_container.get_child_count():
		spawner_container.get_child(i).spawn_interval *= 0.8

func _process(_delta):
	# add properties, +100 because of default stats
	if Global.debug.visible:
		Global.debug.add_property("Enemy Health", enemy_health + 100, 12)
		Global.debug.add_property("Enemy Speed", enemy_speed + 100, 13)
		Global.debug.add_property("Enemy Spawn Scale", enemy_spawn_scale, 14)
		Global.debug.add_property("Enemy Spawn Rate", 5 - spawn_rate, 15)
