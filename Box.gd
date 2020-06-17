extends KinematicBody2D

var description = "It's a wooden box. lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum"
var contents = [] 
var available_actions = {}
var player = null
var motion = Vector2()
var being_moved_by = null
export var blocks_doors = true
export var moveable = false


func _physics_process(delta):
	if self.being_moved_by != null:
		if self.being_moved_by.is_grabbing(self):
			#then I can move diagonally with player
			self.motion = move_and_slide(self.being_moved_by.motion)
		else:
			#then i can only move into one direction
			#check in which direction i should move(only to the side opposite the one the player is standing at)
			#check if player left of me
			print(self.being_moved_by.motion.x, self.being_moved_by.motion.y)
			
			#check if player's left or right edge is less or more than own left or right edge.
			if (self.being_moved_by.report_left_edge() > self.report_right_edge()
				or self.being_moved_by.report_right_edge() < self.report_left_edge()):
					self.motion = self.move(self.being_moved_by.motion.x,0)
			elif (self.being_moved_by.report_top_edge() > self.report_bottom_edge()
				or self.being_moved_by.report_bottom_edge() < self.report_top_edge()):
					self.motion = self.move(0, self.being_moved_by.motion.y)
			else:
				print("Box.gd : No positioning criteria fit!")
			
	else:
		#do nothing
		pass
		
func move(mtn_x = 0, mtn_y = 0):
	return move_and_slide(Vector2(mtn_x,mtn_y))
	

func use(player):
	if self.moveable:
		print("box stick to player")
	else:
		get_tree().call_group("dialog","interact_with_object", player, self, self.actions())
	
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

#############

#Find edges
func report_left_edge():
	return self.global_position.x - ($Sprite.texture.get_size()[0] / 2)

func report_right_edge():
	return self.global_position.x + ($Sprite.texture.get_size()[0] / 2)

func report_top_edge():
	return self.global_position.y - ($Sprite.texture.get_size()[1] / 2)

func report_bottom_edge():
	return self.global_position.y + ($Sprite.texture.get_size()[1] / 2)



func _on_detect_body_lower_body_entered(body):
	if body.name == "Player" or body.name.substr(0,11) == "BoxMoveable":
		z_index = body.z_index - 1

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player" or body.name.substr(0,11) == "BoxMoveable":
		z_index = body.z_index + 1


func _on_PlayerContact_body_entered(body):
	if body.name == "Player" and self.moveable:
		self.being_moved_by = body
			


func _on_PlayerContact_body_exited(body):
	if body.name == "Player" and self.moveable:
		self.being_moved_by = null
		self.motion = Vector2()
