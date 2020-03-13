extends StaticBody2D

var description = "Watch out, behind you!"
var available_actions = []

func actions():
	return available_actions
	
func _on_detect_body_lower_body_entered(body):
	if body.name == "Player":
		z_index = -10

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player":
		z_index = 10
