extends RigidBody2D

@export_group("references")
@export var collider: CollisionShape2D
@export var sprite: Sprite2D
@export var sfx: AudioStreamPlayer

@export_group("stats")
@export var size = 20
@export var spawn_offset = 3

func _ready():
	# move the orb slightly when it spawns so multiple...
	# orbs spawning dont stack on eachother
	var offsetting = true
	var offset = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	apply_force(offset * spawn_offset)
func _on_body_entered(col):
	if col.is_in_group("player"):
		# reference players level script
		col.find_child("level").gain_xp(size)
		
		# remove interactable nodes from scene tree
		collider.queue_free()
		sprite.queue_free()
		
		# play sfx if it exists
		if sfx:
			sfx.play()
		
		# wait some time for sfx to finish
		await get_tree().create_timer(0.3).timeout
		
		# remove from scene tree
		queue_free()
