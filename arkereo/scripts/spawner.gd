extends Marker2D

@export var Enemy: PackedScene
@export var timer_randomization: bool = false

# spawn interval and randimzer multiplier
@export var spawn_interval = 5.0
@export_range(1, 5) var randomizer

# do not touch
var actual_spawn_interval = spawn_interval
var timer = 0

# only make this "true" if the player spawns in radius
@export var playerinradius = false

# do not touch
var can_spawn : bool = false

func _ready():
	# only allow spawning if player is in spawn radius
	can_spawn = playerinradius
	if timer_randomization == true:
		actual_spawn_interval = randf_range(spawn_interval, spawn_interval * randomizer)

func _process(delta):
	timer += delta
	# handle spawning
	if timer >= actual_spawn_interval:
		spawn()

func spawn():
	spawn_interval = get_node("/root/main").spawn_rate
	if can_spawn == true:
		# restart spawn timer
		timer = 0
		
		# spawn the enemy
		var temp = Enemy.instantiate()
		temp.collider.health += get_node("/root/main").enemy_health
		temp.speed += get_node("/root/main").enemy_speed
		temp.global_position = global_position + Vector2(randf_range(-2, 2), randf_range(-2, 2))
		get_parent().add_sibling(temp)

# handle can_spawn
func _on_area_2d_body_entered(col):
	if col.is_in_group("player"):
		can_spawn = true
func _on_area_2d_body_exited(col):
	if col.is_in_group("player"):
		can_spawn = false

# handle can_spawn for the "too close" circle
func _on_area_2d_2_body_entered(col):
	if col.is_in_group("player"):
		can_spawn = false
func _on_area_2d_2_body_exited(col):
	if col.is_in_group("player"):
		can_spawn = true
