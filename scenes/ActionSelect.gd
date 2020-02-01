extends Control

onready var hbox = $DialogBox/HorizontalAlign

func _ready():
	self.visible = false

func toggle_action_select():
	self.visible = not self.visible
	get_tree().paused = not get_tree().paused

func display_actions(action_list):
	toggle_action_select()
	for action in action_list:
		var new_label = Label.new()
		new_label.text = action
		new_label.set("custom_fonts/font", load("res://assets/FONT/Minecraft.ttf"))
		new_label.set("custom_fonts/settings/size", 55)
		hbox.add_child(new_label)
	
	# use call(action) to run passed functions
		
func action_left():
	print("action left")

func action_right():
	print("action right")
	
func action_confirm():
	print("action confirm")
	toggle_action_select()