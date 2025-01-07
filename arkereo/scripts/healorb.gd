extends RigidBody2D

@export_group("references")
@export var collider: CollisionShape2D
@export var sprite: Sprite2D
@export var sfx: AudioStreamPlayer

@export_group("stats")
@export var healing = 25

func _on_body_entered(col):
	if col.is_in_group("player"):
		# reference players health script
		Global.find(col, CollisionShape2D).heal(healing)
		
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
