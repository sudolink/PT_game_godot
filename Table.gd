extends StaticBody2D

#var highlighted = load("res://assets/objects/Table_select.png")
#var idle = load("res://assets/objects/Table_idle.png")
var description = "Watch out, behind you!"
var last_call = null
onready var dialog = get_node("../UI")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_proximity_body_entered(body):
	if body.name == "Player":
		#$Sprite.texture = highlighted
		body.imnear(self)

func _on_proximity_body_exited(body):
	if body.name == "Player":
		#$Sprite.texture = idle
		body.ileft(self)
		dialog.hide()

func interaction(delta):
	if Input.is_action_just_pressed("ui_interact"):
		dialog.typeOut(description)

	last_call = delta
	

func _on_detect_body_lower_body_entered(body):
	if body.name == "Player":
		z_index = -10


func _on_detect_body_upper_body_entered(body):
	if body.name == "Player":
		z_index = 10
