extends Control

@export_group("buttons")
@export var startgame: Control
@export var settings: Control
@export var quit: Control
@export var settingsreturn: Control
@export var settingsmute: Control

@export_group("references")
@export var click_sfx: AudioStreamPlayer
func show_base(choice : bool):
	# disable sub-menus if we are enabling base
	if choice:
		show_settings_menu(false)
	
	startgame.visible = choice
	settings.visible = choice
	quit.visible = choice

func show_settings_menu(choice : bool):
	# disable base if we are enabling settings menu
	if choice:
		show_base(false)
	
	settingsreturn.visible = choice
	settingsmute.visible = choice

func _on_startgame_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	# let sfx_finish
	await get_tree().create_timer(0.03).timeout
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_settings_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	show_settings_menu(true)

func _on_quit_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	# let click_sfx finish
	await get_tree().create_timer(0.03).timeout
	
	get_tree().quit()

func _on_settingsreturn_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	show_base(true)

func _on_settingsmute_toggled(toggle):
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	# let click_sfx finish
	await get_tree().create_timer(0.03).timeout
	
	AudioServer.set_bus_mute(0, toggle)
