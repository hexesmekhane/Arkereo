extends Panel

@export_group("gui")
@export var hide: Array[Control]
@export var forcehide: Control

var wasopen

@export_group("buttons")
@export var resume: Control
@export var restart: Control
@export var settings: Control
@export var mainmenu: Control
@export var quit: Control
@export var settingsreturn: Control
@export var settingsmute: Control

@export_group("references")
@export var click_sfx: AudioStreamPlayer
func _ready():
	Global.pausemenu = self

func pausetoggle(paused : bool):
	visible = !visible
	for i in hide.size():
		hide[i].visible = paused
		
	Engine.time_scale = !paused
	
	show_pause_base(paused)

func show_pause_base(choice : bool):
	# hide sub-menus if enabling pause base
	if choice:
		show_settings_menu(false)
	
	resume.visible = choice
	restart.visible = choice
	settings.visible = choice
	mainmenu.visible = choice
	quit.visible = choice

func show_settings_menu(choice : bool):
	# hide pause base if enabling settings menu
	if choice:
		show_pause_base(false)
	
	settingsreturn.visible = choice
	settingsmute.visible = choice

func _on_resume_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	Global.pause()

func _on_restart_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	Global.pause()
	Global.restart()

func _on_settings_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	show_settings_menu(true)

func _on_mainmenu_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	# let click_sfx finish
	await get_tree().create_timer(0.03).timeout
	
	Global.pause()
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func _on_quit_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	# let clicK_sfx finish
	await get_tree().create_timer(0.03).timeout
	
	get_tree().quit()

func _on_settingsreturn_pressed():
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	show_pause_base(true)

func _on_settingsmute_toggled(toggle):
	# play click_sfx if it exists
	if click_sfx:
		click_sfx.play()
	
	# let click_sfx finish
	await get_tree().create_timer(0.03).timeout
	
	AudioServer.set_bus_mute(0, toggle)
