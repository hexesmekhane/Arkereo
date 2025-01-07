extends Area2D

# this is handled in the gun script
var speed: float
var damage: float
var rot: float
var pierce: int
var knockback: float

# bullet trail
@export var line: Line2D
@export var length = 75

func _physics_process(_delta):
	# prevent the bullet from being moved while paused
	if !Global.paused:
		# bullet movement
		translate(Vector2(1 * speed, 0).rotated(rot))
		line.set_point_position(0, Vector2.ZERO)
		line.set_point_position(1, Vector2(-length, 0))
func _on_bulletcull_timeout():	destroy() 

func destroy():
	queue_free()

func _on_body_entered(col):
	if col.is_in_group("enemy"):
		# knockback
		col.linear_velocity = Vector2(col.linear_velocity + Vector2(knockback, 0).rotated(rot))
		
		# damage
		Global.find(col, CollisionShape2D).take_damage(damage)
		
		# pierce
		if pierce <= 0:
			destroy()
		else:
			pierce -= 1
	else:
		destroy()
