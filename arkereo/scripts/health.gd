extends CollisionShape2D

@export var hit_sfx: AudioStreamPlayer
@export var health = 100 # default health
@export var invuln_frames = 1 # 1 = 1 second

# dont touch
var max_health
var tick = 0

func _ready():
	# set maxhealth to our default health
	max_health = health

func _process(delta):
	tick -= delta
	
	# if we have no health we die
	if health <= 0:
		die()
	
	# add maxhealth stat to debug menu
	Global.debug.add_property("Maximum Health", max_health, 9)

func heal(healing):
	health += healing
	
	# if our health is OVER our maximum health,
	# then we set our health TO maximum health
	if health > max_health:
		health = max_health
	
	# update the gui
	get_node("../../camera").update("health", "HP: " + str(health))
func takedamage(damage):
	if tick <= 0:
		health -= damage
		
		#start invul time
		tick = invuln_frames
		
		# update the gui
		get_node("../../camera").update("health", "HP: " + str(health))
		hit_sfx.play()

# oh no we died so sad :(
func die():
	Global.restart()
