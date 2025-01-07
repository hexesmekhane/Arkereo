extends Camera2D

@export var player: Node
@export var texts: Array[RichTextLabel]

func _process(_delta):
	# make the camera track the player
	global_position = player.global_position

# logic for updating text in the gui
func update(name: String, txt: String):
	for i in texts.size():
		if texts[i].name == name:
			texts[i].text = txt
