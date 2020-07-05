extends KinematicBody2D


const MAX_DRAG_SPEED = 20
const SPEED = 100
var description = "It's a wooden box. lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum"
var contents = [] 
var available_actions = {}
var player = null
var motion = Vector2()

export var blocks_doors = true
export var moveable = false

func _ready():	
	self.available_actions["Leave"] = funcref(self, "leave")

func _physics_process(delta):
	if self.being_moved_by != null:
		if self.being_moved_by.is_grabbing(self):
			#then I can move diagonally with player
			self.motion = move_and_slide(self.being_moved_by.motion)
		else:
			print("box should move in only one dir, away from player.")
	else:
		#do nothing
		pass
		
func move():
	self.motion = move_and_slide(self.motion)

func move_deprecated(mtn_x = 0, mtn_y = 0):
	self.motion = move_and_slide(Vector2(mtn_x,mtn_y))

func use(player):
	if self.moveable:
		print("box stick to player")
	else:
		get_tree().call_group("dialog","interact_with_object", player, self, self.actions())

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



#### For displaying/drawing the box behind/over the player as needed
func _on_detect_body_lower_body_entered(body):
	if body.name == "Player" or body.name.substr(0,11) == "BoxMoveable":
		z_index = body.z_index - 1

func _on_detect_body_upper_body_entered(body):
	if body.name == "Player" or body.name.substr(0,11) == "BoxMoveable":
		z_index = body.z_index + 1


#### Detect player contact

func _on_PlayerContact_body_entered(body):
	if body.name == "Player" and self.moveable:
		print(body.name, "contact!")
		#self.being_moved_by = body
		#self.being_moved_by.set_pushing_box(self)

func _on_PlayerContact_body_exited(body):
	if body.name == "Player" and self.moveable:
		print(body.name, " left!")
		#self.being_moved_by.clear_pushing_box(self)
		#self.being_moved_by = null
		#self.motion = Vector2(0,0)


