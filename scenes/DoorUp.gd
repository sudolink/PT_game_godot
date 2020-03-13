extends StaticBody2D

var description = "Doors are for going through"
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
		
		
func use():
	if not open:
		$AnimatedSprite/OpenClose.play("OpenDown")
		open = true
	else:
		$AnimatedSprite/OpenClose.play("CloseUp")
		open = false
#	if not open:
#		if not player_above:
#			$AnimatedSprite/OpenClose.play("OpenDown")
#			open = true
#		else:
#			$AnimatedSprite/OpenClose.play("OpenUp")
#			open = true
#	else:
#		if $AnimatedSprite.animation == "OpenDown":
#			$AnimatedSprite/OpenClose.play("CloseUp")
#			open = false
#		else:
#			$AnimatedSprite/OpenClose.play("CloseDown")
#			open = false

