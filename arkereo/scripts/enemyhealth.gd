extends CollisionShape2D

# references
@export var xporb: PackedScene
@export var healorb: PackedScene
@export var timer: Timer
@export var hit_sfx: AudioStreamPlayer
@export var die_sfx: AudioStreamPlayer
@export var sprite: Sprite2D
# stats
@export var health = 100
@export var xporb_count = 1
var max_health

var stunned: bool = false

func _ready():
	# our max health is whatever we set our default health to
	max_health = health

func _process(_delta):
	if health <= 0:
		die()

func take_damage(damage):
	health -= damage
	
	# get stunned on hit
	stunned = true
	
	# play hit sound if it exists
	if hit_sfx:
		hit_sfx.play()
	
	timer.start()

func die():
	get_parent().dead = true
	
	# allow for spawning multiple xporbs
	for i in xporb_count:
		var _xporb = xporb.instantiate()
		get_parent().add_sibling(_xporb)
		_xporb.global_position = global_position
	
	# spawn a healing orb based on healorb_chance as a percentage
	var ranum = randi_range(0, 100)
	if ranum <= Global.healorb_chance:
		var _healorb = healorb.instantiate()
		get_parent().add_sibling(_healorb)
		_healorb.global_position = global_position
	
	#play death sound if it exists
	if die_sfx:
		die_sfx.play()
	
	# remove collider and sprite from scene tree
	queue_free()
	sprite.queue_free()
	
	#wait for .3 seconds to allow the sound effect to finish
	await get_tree().create_timer(.3).timeout
	
	# remove the enemy itself from the scene tree
	get_parent().queue_free()


func _on_timer_timeout():
	stunned = false
