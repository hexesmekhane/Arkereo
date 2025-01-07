extends Node2D

@export_group("references")
@export var cam: Camera2D
@export var levelup_sfx: AudioStreamPlayer
@export var movement: Node
@export var gun: Node
@export var health: Node
@export_group("stats")
@export var xp = 0
@export var xp_in_lvl = 100
@export var lvl = 0

# dont touch
var upgrades = 0
var upgrade_idx = [0, 0, 0]
var upgrading : bool

var spread_debt = 0
func _process(_delta):
	Global.debug.add_property("XP for levelup", xp_in_lvl, 11)
	
	if xp >= xp_in_lvl:
		levelup()
		cam.update("xp", "XP: " + str(xp))
	if upgrades < lvl and upgrading:
		if Input.is_action_just_pressed("option1"):
			upgrade(0)
		elif Input.is_action_just_pressed("option2"):
			upgrade(1)
		elif Input.is_action_just_pressed("option3"):
			upgrade(2)
	
	# if we have levelled up before we chose an upgrade...
	# regenerate upgrades after each choice until we have one for each level
	elif upgrades < lvl and !upgrading:
		upgradegen()

func gain_xp(gainedxp):
	xp += gainedxp
	cam.update("xp", "XP: " + str(xp))

func levelup():
	# play levelup_sfx if it exists
	if levelup_sfx:
		levelup_sfx.play()
	
	# remove xp that was used in levelling up
	xp -= xp_in_lvl
	
	# if we somehow go negative in xp, set it to 0
	if xp < 0:
		xp = 0
	
	#increase lvl by 1 and increase xp_in_lvl
	lvl += 1
	xp_in_lvl += 20
	
	# generate an upgrade if we arent in the middle of choosing
	if !upgrading:
		upgradegen()
	cam.update("level", "LVL: " + str(lvl))

func upgradegen():
	upgrading = true
	for i in 3:
		# manage which option we are changing
		var option: String
		match i:
			0:
				option = "option1"
			1:
				option = "option2"
			2:
				option = "option3"
		var ranum = randi_range(1, 9)
		upgrade_idx[i] = ranum
		match ranum:
				1:
					cam.update(option, str(i + 1) + ": +100 speed")
				2:
					cam.update(option, str(i + 1) + ": +1 bullet")
				3:
					cam.update(option, str(i + 1) + ": +20% firerate")
				4:
					cam.update(option, str(i + 1) + ": +20 damage")
				5:
					cam.update(option, str(i + 1) + ": +25 max health")
				6:
					cam.update(option, str(i + 1) + ": +1 piercing")
				7:
					cam.update(option, str(i + 1) + ": -20 spread")
				8:
					cam.update(option, str(i + 1) + ": +50 knockback")
				9:
					cam.update(option, str(i + 1) + ": +5% healorb drop chance")
func upgrade(idx):
	upgrades += 1
	match upgrade_idx[idx]:
		1:
			movement.speed += 100
		2:
			gun.bullets_per_shot += 1
			gun.variance += 0.1
			if spread_debt >= -10:
				gun.spread += 10 + spread_debt
			spread_debt - 10
			gun.damage *= 0.75
		3:
			gun.fire_rate *= 0.8
		4:
			gun.damage += 20
		5:
			health.max_health += 25
			health.heal(25)
		6:
			gun.pierce += 1
		7:
			gun.spread -= 20
			if gun.spread < 0:
				spread_debt = gun.spread
				gun.spread = 0
		8:
			gun.knockback *= 2
		9:
			Global.healorb_chance += 5
	upgrading = false
	cam.update("option1", " ")
	cam.update("option2", " ")
	cam.update("option3", " ")
