extends Node

var player
var pausemenu
var debug

var paused : bool
var healorb_chance : int = 5

# being a script outside of the scene tree we can
# handle pause inputs regardless of timescale
func _unhandled_input(event):
	if event.is_action_pressed("pause") and pausemenu:
		pause()

# toggle pause
func pause():
	paused = !paused
	pausemenu.pausetoggle(paused)

# restart the game
func restart():
	player.queue_free()
	get_tree().reload_current_scene()

# function for all scripts to use in order to find nodes by type
func find(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
		#var grandchild = find(child, type)
		#if grandchild != null:
			#return grandchild
	return null
