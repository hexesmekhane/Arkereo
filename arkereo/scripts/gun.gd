extends Sprite2D

@export_group("references")
@export var bullet: PackedScene 
@export var gunshot_sfx: AudioStreamPlayer
@export_group("bullet")
@export var damage = 20 # how much damage the bullet does
@export var speed = 30 # how fast the bullet travels
@export var pierce = 0 # how many enemies we can go through before the bullet is stopped
@export var knockback = 100 # how far the enemies are pushed back when hit

@export_group("gun")
@export var fire_rate = .5 # how fast we can shoot (1 = 1 second)
@export var spread = 0 # in degrees, how far the bullets can stray from the direction they were shot
@export var bullets_per_shot = 1 # bullets shot per shoot() call
@export var variance = 1 # bullet speed multiplier, use "1" for consistent speed

# dont touch
var rate = 0
func _process(delta):
	# shoot on fire_rate intervals
	if Input.is_action_pressed("shoot") and rate <= 0 and !Global.paused:
		shoot()
		rate = fire_rate
	elif rate > 0:
		rate = rate - delta
	
	# add properties to debug menu
	Global.debug.add_property("Bullet Damage", damage, 2)
	Global.debug.add_property("Bullet Pierce", pierce, 3)
	Global.debug.add_property("Bullet Knockback", knockback, 4)
	Global.debug.add_property("Fire Rate", fire_rate, 5)
	Global.debug.add_property("Spread", spread, 6)
	Global.debug.add_property("Bullets Per Shot", bullets_per_shot, 7)
	Global.debug.add_property("Bullets Speed Variance", variance, 8)

func shoot():
	# play gunshot sound if the gunshot sound exists
	if gunshot_sfx:
		gunshot_sfx.play()
	
	# shoot a bullet for each bullet_per_shot
	for i in bullets_per_shot:
		var _bullet = bullet.instantiate()
		var parent = get_parent()
		var _spread = deg_to_rad(randf_range(-spread, spread) * 0.5)
		var _variance = randf_range(1, variance)
		parent.add_sibling(_bullet)
		
		# manage bullet behaviour
		_bullet.global_position = get_node("shotpoint").get("global_position")
		_bullet.look_at(get_global_mouse_position())
		_bullet.set("rot", (_bullet.global_rotation + _spread))
		_bullet.set("speed", (speed * _variance))
		_bullet.set("damage", damage)
		_bullet.set("pierce", pierce)
		_bullet.set("knockback", knockback)
