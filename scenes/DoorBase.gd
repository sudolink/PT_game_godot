extends StaticBody2D

export var open = false
var available_actions = {}
var obstructions = {}
var description = "Door description placeholder (DoorBase)"
var player = null
export var locked = false
export var key = 00

func use(player_object):
	set_player(player_object)
	try_open(player)

func set_player(player_object):
	self.player = player_object

func actions():
	return available_actions

func door_open():
	if not open:
		$AnimationHandler.play("Open")
		open = true
	else:
		$AnimationHandler.play("Close")
		open = false

func is_blocked():
	return len(self.obstructions) > 0

func unlock(player_obj):
	if player_obj.keys:
		print("player has keys")
	self.locked = false

func try_open(player):
	#try to open it, if locked, open dialogue
	print("came to try open!")
	if self.locked:
		self.description = "It's locked.'"
		get_tree().call_group("dialog","interact_with_object", player, self, self.actions())
	else:
		if self.is_blocked():
			self.description = "The door won't budge. Something's blocking it."
			get_tree().call_group("dialog","interact_with_object", player, self, self.actions())
		else:
			door_open()

func leave():
	get_tree().call_group("interface", "hide_dialog")
	
func only_leave_left():
	if len(self.available_actions) == 1 and self.available_actions.has("Leave"):
		print("Only leave function left, close dialog automatically-")
		leave()
