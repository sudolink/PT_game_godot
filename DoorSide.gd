extends StaticBody2D

var open = false
export var open_left = false  #door opens to the left side if true
export var open_from_left = false #door can be opened only from the left side if true
export var locked = false #locked or not
export var key = 33 #int id of key - only used if locked is true

func use(player):
	print(player.global_position.x," vs ",self.global_position.x)
	if player.global_position.x < self.global_position.x and open_from_left: #player is on left and door opens left
		door_open()
	elif player.global_position.x > self.global_position.x and not open_from_left:
		door_open()
	else:
		print("you cunt open the door")
		


func door_open():
	if open_left:
		if not open:
			$AnimationHandler.play("OpenLeft")
			open = true
		else:
			$AnimationHandler.play("CloseLeft")
			open = false
	else:
		if not open:
			$AnimationHandler.play("OpenRight")
			open = true
		else:
			$AnimationHandler.play("CloseRight")
			open = false

func _on_interact_field_body_entered(body):
	if body.name == "Player":
		body.met_door(self)


func _on_interact_field_body_exited(body):
	if body.name == "Player":
		body.met_door(null)
	



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
