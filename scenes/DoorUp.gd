extends StaticBody2D

var description = "Doors are for going through"
onready var dialog = get_node("../../UI")
var open = false
var player_above = false

func _on_LowerRender_body_entered(body):
	if body.name == "Player":
		z_index = -10
		player_above = true

func _on_UpperRender_body_entered(body):
	if body.name == "Player":
		z_index = 10
		player_above = false
		



func interaction():
	if Input.is_action_just_pressed("ui_interact"):
		dialog.typeOut(description)
	elif Input.is_action_just_pressed("use"):
		attempt_open()
		
func attempt_open():
	if not open:
		if not player_above:
			$AnimatedSprite/OpenClose.play("OpenDown")
			open = true
		else:
			$AnimatedSprite/OpenClose.play("OpenUp")
			open = true
	else:
		if $AnimatedSprite.animation == "OpenDown":
			$AnimatedSprite/OpenClose.play("CloseUp")
			open = false
		else:
			$AnimatedSprite/OpenClose.play("CloseDown")
			open = false

func _on_proximity_body_entered(body):
	if body.name == "Player":
		body.imnear(self)

func _on_proximity_body_exited(body):
	if body.name == "Player":
		body.ileft(self)
		dialog.hide()
