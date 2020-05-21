extends StaticBody2D

var description = "Watch out, behind you!"
var available_actions = {}
var player = null

func _ready():
	self.available_actions["Leave"] = funcref(self, "leave")

func set_player(player):
	self.player = player

func actions():
	return available_actions
	
func leave():
	get_tree().call_group("interface", "hide_dialog")
	
func _on_detect_body_lower_body_entered(body):
	if body.name == "Player":
		z_index = -10

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player":
		z_index = 10
