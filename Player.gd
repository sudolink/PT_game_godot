extends KinematicBody2D


const SPEED = 100
const DSPEED = SPEED * 0.7
const DIRECTIONS = ["ui_left","ui_right","ui_down","ui_up"]
const DIR_ACTION = {"ui_left":[-SPEED,0],"ui_right":[SPEED,0],"ui_up":[0,-SPEED],"ui_down":[0,SPEED]}


signal direction_change(new_direction)
var motion = Vector2()
var direction = "up"
var is_idle = false
var at_door = null
var grabbing = null
var pushing_box = null
var interacting_with = null

onready var collision_shape = $collision
onready var inventory = get_node("PlayerInventory")
onready var interaction_ray = $InteractionRay


func _ready():
	return connect("direction_change",interaction_ray,"direction_changed")


func _physics_process(delta):
	update()
	interaction_ray.force_raycast_update()
	
	motion = Vector2()

	var moving = allowed_directions()
	if moving:
		set_motion(moving)
	else:
		set_motion("idle")

	## MOVEMENT
	motion.x *= delta*SPEED/2
	motion.y *= delta*SPEED/2
	
	#if pushing box, send it the movement
	if self.pushing_box != null:
		self.pushing_box.move_and_slide(self.motion)
	
	motion = move_and_slide(motion)
	
	
	
	light_switch()
	
	if at_door: #door interaction currently takes precedence over interacting with anything else
		interaction(at_door)
	elif interacting_with and not at_door:
		interaction(interacting_with)
		

func _draw():
	draw_line(interaction_ray.ray_offset, interaction_ray.cast_to+interaction_ray.ray_offset, Color(255, 0, 0), 1)

func set_idle(travolta):
	if travolta == "johntravolta":
		$Sprite.play("Idle")
	else:
		if not is_idle:
			$Sprite.animation = "Idle"
			if direction == "up":
				$Sprite.frame = 0
			elif direction == "down":
				$Sprite.frame = 6
			elif direction == "left":
				$Sprite.frame = 4
			elif direction == "right":
				$Sprite.frame = 5
			elif direction == "upleft":
				$Sprite.frame = 1
			elif direction == "upright":
				$Sprite.frame = 2
			elif direction == "downleft":
				$Sprite.frame = 7
			elif direction == "downright":
				$Sprite.frame = 6
			else:
				print("WHOOPSIE IN SET_IDLE")
			is_idle = true


func set_motion(dir):
	if "idle" in dir:
		motion.y = 0
		motion.x = 0
		set_idle(null)
	else:
		if "ui_up" in dir:
			if "ui_left" in dir:
				motion.x = -DSPEED
				motion.y = -DSPEED
				$Sprite.play("upLeftDiag")
				direction = "upleft"
			elif "ui_right" in dir:
				motion.x = DSPEED
				motion.y = -DSPEED
				$Sprite.play("upRightDiag")
				direction = "upright"
			else:
				motion.y = -SPEED
				$Sprite.play("upWalk")
				set_collision_shape(7,4)
				direction = "up"
		elif "ui_down" in dir:
			if "ui_left" in dir:
				motion.x = -DSPEED
				motion.y = DSPEED
				$Sprite.play("downLeftDiag")
				direction = "downleft"
			elif "ui_right" in dir:
				motion.x = DSPEED
				motion.y = DSPEED
				$Sprite.play("downRightDiag")
				direction = "downright"
			else:
				motion.y = SPEED
				$Sprite.play("downWalk")
				set_collision_shape(7,4)
				direction = "down"
		elif "ui_left" in dir:
			motion.x = -SPEED
			$Sprite.play("leftWalk")
			set_collision_shape(10,4)
			direction = "left"
		elif "ui_right" in dir:
			motion.x = SPEED
			$Sprite.play("rightWalk")
			set_collision_shape(10,4)
			direction = "right"
		is_idle = false
		emit_signal("direction_change",direction)
		

func set_collision_shape(x,y):
	var new_shape = RectangleShape2D.new()
	var new_vec = Vector2(x,y)
	new_shape.set_extents(new_vec)
	collision_shape.set_shape(new_shape)

func allowed_directions():
	#get list of movement buttons pressed
	var pressed_list = []
	for direction in DIRECTIONS:
		if Input.is_action_pressed(direction):
			pressed_list.append(direction)
	if len(pressed_list) > 2: #crop number of pressed directions to 2 if more are present
		pressed_list.resize(2)
		if opposite_directions(pressed_list):
			pressed_list.resize(0)

	return pressed_list

func opposite_directions(dirlist):
	var opposites = {"ui_up":"ui_down","ui_left":"ui_right","ui_down":"ui_up","ui_right":"ui_left"}
	return opposites[dirlist[0]] == dirlist[1]


############## ACTIONS ################

func light_switch():
	if Input.is_action_just_pressed("ui_select"):
		if $circlight.enabled:
			$circlight.enabled = false
		else:
			$circlight.enabled = true

func grab(object):
	self.grabbing = object	

############ INTERACTION ###################

func interaction_distance(object):
	return self.global_position.distance_to(object.global_position) < 40

func interaction(object):
	if Input.is_action_just_pressed("ui_interact"):
		if interaction_distance(object):
			object.use(self)
#			#if object is intended to be interacted with through the dialog, then proceed to send its details to the dialog
#			if object.has_method("actions"):
#				get_tree().call_group("dialog","interact_with_object", self, object, object.actions())
#			else:
#			#if it does not, then it has to have the use function, which only performs one action - go ahead and perform that (door opening/closing, crowbarring stuff)
#				object.use(self)
		else:
			print("not close enough!")

func met_door(door):
	at_door = door
	if door != null:
		get_tree().call_group("interface", "see_an_object", at_door)

func met_interactable(object):
	interacting_with = object
	get_tree().call_group("interface","see_an_object", interacting_with)

func set_pushing_box(box):
	self.pushing_box = box

func clear_pushing_box(box):
	self.pushing_box = null

############### QUERIES ####################
func is_grabbing(object):
	return object == self.grabbing
	

func has_crowbar():
	return inventory.has_item("Crowbar")
	
func report_size():
	#ugly hack, reports extents of sprite, using first frame of the idle animation
	return $Sprite.frames.get_frame("Idle",0).get_size()
	
  #### The below functions take the player's global position and
	### subtract or add half the player's width or height - to find the sprite's edges.
	### EDIT: Modified to find edges of collision shape - because that's what is actually needed.
	
func report_left_edge():
	return self.global_position.x - ($collision.get_shape().get_extents().x / 2)

func report_right_edge():
	return self.global_position.x + ($collision.get_shape().get_extents().x / 2)

func report_top_edge():
	return (self.global_position.y + $collision.position.y) - ($collision.get_shape().get_extents().y / 2)
	
func report_bottom_edge():
	return (self.global_position.y + $collision.position.y) + ($collision.get_shape().get_extents().y / 2)

func report_collision_center():
	return self.global_position + $collision.position
