extends StaticBody2D

var description = "It's a wooden box. lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum"
var contents = [] 
var available_actions = {}
var player = null

func use():
	pass
	
func _ready():
	self.available_actions["Leave"] = funcref(self, "leave")

func set_player(player):
	self.player = player
	
func actions():
	return available_actions
	
	
func only_leave_left():
	if len(self.available_actions) == 1 and self.available_actions.has("Leave"):
		print("Only leave function left, close dialog automatically-")
		leave()

func leave():
	get_tree().call_group("interface", "hide_dialog")

func _on_detect_body_lower_body_entered(body):
	if body.name == "Player":
		z_index = -10

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player":
		z_index = 10
