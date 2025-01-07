extends Node2D

var difficulty_scale : int = 1
var enemy_health = 0
var enemy_speed = 0
var spawn_rate = 0.0
@export var cam : Node
@export var spawner_container : Node

func _on_timer_timeout():
	# incrememnt difficulty scale
	difficulty_scale += 1
	cam.update("difficulty", "Difficulty: " + str(difficulty_scale))
	
	# adjust enemy stats
	enemy_health += 20
	enemy_speed += 20
	
	# increase enemy spawnrate
	for i in spawner_container.get_child_count():
		spawner_container.get_child(i).spawn_interval *= 0.8
	
	# add properties, +100 because of default stats
	Global.debug.add_property("Enemy Health", enemy_health + 100, 12)
	Global.debug.add_property("Enemy Health", enemy_speed + 100, 13)
