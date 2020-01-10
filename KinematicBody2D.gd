extends KinematicBody2D

const SPEED = 100
const DSPEED = SPEED * 0.7
const DIRECTIONS = ["ui_left","ui_right","ui_down","ui_up"]
const DIR_ACTION = {"ui_left":[-SPEED,0],"ui_right":[SPEED,0],"ui_up":[0,-SPEED],"ui_down":[0,SPEED]}
var motion = Vector2()
var interacting_with = null

onready var collision_shape = $collision


func _physics_process(delta):
	
	motion = Vector2()
	
	var moving = allowed_directions()
	if moving:
		set_motion(moving)
	else:
		set_motion("idle")
	
	motion.x *= delta*SPEED/2
	motion.y *= delta*SPEED/2
	motion = move_and_slide(motion)
	light_switch()
	
	if interacting_with:
		interacting_with.interaction(delta)

func set_motion(dir):
	if "idle" in dir:
		motion.y = 0
		motion.x = 0
		$Sprite.play("Idle")
	else:
		if "ui_up" in dir:
			if "ui_left" in dir:
				motion.x = -DSPEED
				motion.y = -DSPEED
				$Sprite.flip_h = false
				$Sprite.play("upDiag")
			elif "ui_right" in dir:
				motion.x = DSPEED
				motion.y = -DSPEED
				$Sprite.flip_h = true
				$Sprite.play("upDiag")
			else:
				motion.y = -SPEED
				$Sprite.play("upWalk")
				set_collision_shape(12,12)
		elif "ui_down" in dir:
			if "ui_left" in dir:
				motion.x = -DSPEED
				motion.y = DSPEED
				$Sprite.flip_h = false
				$Sprite.play("downDiag")
			elif "ui_right" in dir:
				motion.x = DSPEED
				motion.y = DSPEED
				$Sprite.flip_h = true
				$Sprite.play("downDiag")
			else:
				motion.y = SPEED
				$Sprite.play("downWalk")
				set_collision_shape(12,12)
		elif "ui_left" in dir:
			motion.x = -SPEED
			$Sprite.flip_h = false
			$Sprite.play("hWalk")
			set_collision_shape(19,12)
		elif "ui_right" in dir:
			motion.x = SPEED
			$Sprite.flip_h = true
			$Sprite.play("hWalk")
			set_collision_shape(19,12)
		


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
	
func light_switch():
	if Input.is_action_just_pressed("ui_select"):
		if $circlight.enabled:
			$circlight.enabled = false
		else:
			$circlight.enabled = true


func imnear(object):
	interacting_with = object 
	print("I'm near ->",object.name)

func ileft(object):
	interacting_with = null
	print("i left ->",object.name)

