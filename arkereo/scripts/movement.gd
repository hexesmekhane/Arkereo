extends RigidBody2D

@export var speed = 400

# dont touch
var direction

func _ready():
	Global.player = self

func _physics_process(_delta):
	# apply movement based on direction
	direction = Input.get_vector("left", "right", "down", "up")
	linear_velocity = direction * speed
	
	# look towards cursor when unpaused
	var mousepos = Vector2(get_global_mouse_position().x, get_global_mouse_position().y)
	if !Global.paused:
		look_at(mousepos)
	
	# add speed property to debug menu
	Global.debug.add_property("Player Speed", speed, 1)
