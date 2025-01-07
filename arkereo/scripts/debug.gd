extends Panel

@export var property_container: VBoxContainer

func _ready():
	visible = false
	Global.debug = self

func _process(delta):
	# calculatae fps
	var fps = "%.2f" % (1.0/delta)
	
	# add properties
	add_property("FPS", fps, 0)
	add_property("Healorb Drop Chance", Global.healorb_chance, 10)

# toggle the debug menu
func _input(event):
	if event.is_action_pressed("debug"):
		visible = !visible

func add_property(title: String, value, order: int):
	# find the target via title
	var target
	target = property_container.find_child(title, true, false)
	
	# if we cant find the target, then we create a new label
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	
	# if we find the target, then we update the label
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
