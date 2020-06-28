extends KinematicBody2D

var description = "It's a wooden box. lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum"
var contents = [] 
var available_actions = {}
var player = null
var motion = Vector2()
var being_moved_by = null
var player_motion = null
export var blocks_doors = true
export var moveable = false


func _physics_process(delta):
	if self.being_moved_by != null:
		if self.being_moved_by.is_grabbing(self):
			#then I can move diagonally with player
			self.motion = move_and_slide(self.being_moved_by.motion)
		else:
				#print(self.being_moved_by.report_top_edge(), "---",self.report_bottom_edge())
			#check if player is below box
			if self.being_moved_by.report_top_edge() > self.report_bottom_edge():# and self.within_pushing_params(self.being_moved_by):
				print("is below box")
				self.motion = move(0,self.player_motion.y)
			#check if player is above box
			elif self.being_moved_by.report_bottom_edge() < self.report_top_edge():# and self.within_pushing_params(self.being_moved_by):
				print("is above box")
				self.motion = move(0,self.player_motion.y)
			#check if player is left of box
			elif self.being_moved_by.report_right_edge() < self.report_left_edge():# and self.within_pushing_params(self.being_moved_by):
				print("is left of box")
				self.motion = move(self.player_motion.x,0)
			#check if player is right of box
			elif self.being_moved_by.report_left_edge() > self.report_right_edge():# and self.within_pushing_params(self.being_moved_by):
				print("is right of box")
				self.motion = move(self.player_motion.x,0)
			else:
				print("Box.gd: locational logic missed a case")
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

#set player motion
func set_player_motion(pmotion):
	self.player_motion = pmotion

#Find edges
func report_left_edge():
	return self.global_position.x - ($CollisionShape2D.get_shape().get_extents().x / 2)

func report_right_edge():
	return self.global_position.x + ($CollisionShape2D.get_shape().get_extents().x / 2)

func report_top_edge():
	return self.global_position.y - ($CollisionShape2D.get_shape().get_extents().y / 2)

func report_bottom_edge():
	return self.global_position.y + ($CollisionShape2D.get_shape().get_extents().y / 2)

#Find player body is within an acceptable positional relation to self - for box pushing
func within_pushing_params(other_body):
	#take the center of the body's collision, and check whether that center
	#is between either the left and right edges of the box, or the top and bottom edges
	#check for x first, then y
	var body_pos = other_body.report_collision_center()
	return (body_pos.x > self.report_left_edge() and body_pos.x < self.report_right_edge()) or (body_pos.y > self.report_bottom_edge() and body_pos.y < self.report_top_edge())


func _on_detect_body_lower_body_entered(body):
	if body.name == "Player" or body.name.substr(0,11) == "BoxMoveable":
		z_index = body.z_index - 1

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player" or body.name.substr(0,11) == "BoxMoveable":
		z_index = body.z_index + 1


func _on_PlayerContact_body_entered(body):
	if body.name == "Player" and self.moveable:
		self.being_moved_by = body
		self.being_moved_by.set_pushing_box(self)
			


func _on_PlayerContact_body_exited(body):
	if body.name == "Player" and self.moveable:
		self.being_moved_by.clear_pushing_box(self)
		self.being_moved_by = null
		self.motion = Vector2()
