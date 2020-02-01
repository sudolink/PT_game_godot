extends StaticBody2D

var description = "Watch out, behind you!"


func _on_proximity_body_entered(body):
	if body.name == "Player":
		body.imnear(self)

func _on_proximity_body_exited(body):
	if body.name == "Player":
		body.ileft(self)
	
func _on_detect_body_lower_body_entered(body):
	if body.name == "Player":
		z_index = -10

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player":
		z_index = 10
