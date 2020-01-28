extends StaticBody2D

var description = "Watch out, behind you!"
onready var dialog = get_node("../../UI")


func _on_proximity_body_entered(body):
	if body.name == "Player":
		body.imnear(self)

func _on_proximity_body_exited(body):
	if body.name == "Player":
		body.ileft(self)
		dialog.hide()

func interaction():
	if Input.is_action_just_pressed("ui_interact"):
		dialog.typeOut(description)
	
func _on_detect_body_lower_body_entered(body):
	if body.name == "Player":
		z_index = -10

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player":
		z_index = 10
