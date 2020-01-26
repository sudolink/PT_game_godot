extends StaticBody2D


#var highlighted = load("res://assets/objects/Box_select.png")
#var idle = load("res://assets/objects/Box_idle.png")
var description = "It's a wooden box."
var last_call = null
onready var dialog = get_node("../UI")


# Called when the node enters the scene tree for the first time.

func _on_proximity_body_entered(body):
	if body.name == "Player":
		#$Sprite.texture = highlighted
		body.imnear(self)


func _on_proximity_body_exited(body):
	if body.name == "Player":
		#$Sprite.texture = idle
		dialog.hide()
		body.ileft(self)

func interaction(delta):
	if Input.is_action_just_pressed("ui_interact"):
		dialog.typeOut(description)
	last_call = delta

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player":
		z_index = 10


func _on_detect_body_lower_body_entered(body):
	if body.name == "Player":
		z_index = -10
