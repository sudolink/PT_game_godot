extends KinematicBody2D

const SPEED = 200
const DIRECTIONS = ["ui_left","ui_right","ui_down","ui_up"]
const DIR_ACTION = {"ui_left":[-SPEED,0],"ui_right":[SPEED,0],"ui_up":[0,-SPEED],"ui_down":[0,SPEED]}
var motion = Vector2()

onready var collision_shape = $collision


func _physics_process(delta):
	
	motion = Vector2()
	
	var moving = allowed_directions()
	if moving:
		if len(moving) > 1:
			for direction in moving:
				set_motion(direction)
		else:
			set_motion(moving[0])
	else:
		set_motion("idle")
	
	motion = move_and_slide(motion)
	light_switch()

func set_motion(dir):
	if dir == "ui_left":
		set_collision_shape(32,16)
		$Sprite.flip_h = false
		$Sprite.play("hWalk")
		motion.x = -SPEED
	elif dir == "ui_right":
		set_collision_shape(32,16)
		$Sprite.flip_h = true
		$Sprite.play("hWalk")
		motion.x = SPEED
	elif dir == "ui_down":
		set_collision_shape(16,16)
		$Sprite.play("downWalk")
		motion.y = SPEED
	elif dir == "ui_up":
		set_collision_shape(16,16)
		$Sprite.play("upWalk")
		motion.y = -SPEED
	else:
		motion.y = 0
		motion.x = 0
		$Sprite.play("Idle")


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
		opposite_directions(pressed_list)
	
	return pressed_list
	

func opposite_directions(dirlist):
	var opposites = {"ui_up":"ui_down","ui_left":"ui_right","ui_down":"ui_up","ui_right":"ui_left"}
	print(opposites[dirlist[0]])
	
func light_switch():
	if Input.is_action_pressed("ui_select"):
		$circlight.enabled = true
	else:
		$circlight.enabled = false
