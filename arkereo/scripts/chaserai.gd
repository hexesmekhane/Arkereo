extends RigidBody2D

# dont touch
var player: Node
var is_damaging = false
var dead: bool

# stats
@export var speed = 200
@export var damage = 25

@export var collider: CollisionShape2D
@export var navigation_agent: NavigationAgent2D

func _ready():
	# get the player and adjust the navagent path accordingly
	player = get_node("/root/main/player")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta):
	# there is a brief period where there is no collision...
	# and no sprite, we dont want anything to happen in this period	
	if dead:
		return
	
	# control the desired direction
	actor_setup()
	var next_path_position : Vector2 = navigation_agent.get_next_path_position()
	
	# move the player only if the player and our collision exist
	if player and collider:
		# if we are stunned, stop moving
		if collider.stunned == false:
			# movement logic
			look_at(next_path_position)
			linear_velocity = Vector2(speed, 0).rotated(global_rotation)
	# apply damage
	if is_damaging == true:
		Global.find(player, CollisionShape2D).takedamage(damage)

func actor_setup():
	# wait for the first physics frame so the navigationserver can sync.
	await get_tree().physics_frame
	
	set_movement_target(player.global_position)

func _on_body_entered(col):
	if col.is_in_group("player"):
		is_damaging = true

func _on_body_exited(col):
	if col.is_in_group("player"):
		is_damaging = false
