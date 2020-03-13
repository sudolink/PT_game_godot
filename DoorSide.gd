extends StaticBody2D

var open = false


func use(player):
	if not open:
		$AnimationHandler.play("OpenLeft")
		open = true
	else:
		$AnimationHandler.play("CloseLeft")
		open = false


#func _on_FrontLower_body_entered(body):
#	if body.name == "Player":
#		$Frontside.z_index = body.z_index - 1
#
#
#func _on_FrontUpper_body_entered(body):
#	if body.name == "Player":
#		$Frontside.z_index = body.z_index + 1
#
#
#func _on_BackUpper_body_entered(body):
#	if body.name == "Player":
#		$Backside.z_index = body.z_index + 1
#
#
#func _on_BackLower_body_entered(body):
#	if body.name == "Player":
#		$Backside.z_index = body.z_index - 1
