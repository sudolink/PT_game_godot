extends Control

const SCROLL_SPEED = 0.5
var interacting_with = null
var parent = null
onready var action_scroll = $ActionScroll/VBoxContainer
onready var description_window = $DialogText/TextBox


func _ready():
	$DialogText/TextBox.percent_visible = 0

func _process(delta):
	if self.visible:
		text_effect(delta)


###### TEXT EFFECTS
func text_effect(delta):
							#FIX THIS, COMES IN FASTER THE MORE TEXT THERE IS, AND SLOWER, THE LESS THERE IS
	if $DialogText/TextBox.percent_visible != 1:
		$DialogText/TextBox.percent_visible += delta * SCROLL_SPEED


##### RESET DIALOG VARIABLES AND TOGGLES
func reset():
	#reset DialogText/TextBox scroll value, and visibility
	$DialogText.reset()
	#TextHandler.reset_state()
	
	#Wipe the ActionScroll contents
	wipe_buttons()


##### ACTIONS
func interact_with_object(player, object, actions = null):
	interacting_with = object
	object.set_player(player)
	description_window.set_text(get_description(interacting_with))
	#MAKE THE BUTTONS
	wipe_buttons()
	make_buttons(actions)
	#open the dialog interface
	get_parent().show_dialog()
	print("number of lines: ",$DialogText.get_last_line_number())
	$TextHandler.grab_focus()

func get_description(object):
	return object.description if object.description != null else "No description set"	

func action_taken(button):
	update_state()
	force_focus($ActionScroll/VBoxContainer.get_child(0)) #first control from action_scroll grabs focus
		

###### OBJECT STATE
func update_state():
	#update object description
	description_window.set_text(get_description(interacting_with))
	#wipe buttons,
	#then get new functions, if any
	var new_actions = interacting_with.actions()
	wipe_buttons()
	make_buttons(new_actions)

###### BUTTONS

func force_focus(node_to_focus):
	if node_to_focus != null:
		#print(node_to_focus, "grabbed focus")
		node_to_focus.grab_focus()
	else:
		print(node_to_focus, " is not a valid node to focus")

func new_action_button(text,function):
	var new_button = load("res://scenes/ActionButton.tscn").instance()
	new_button.set_up(text, function)
	return new_button

func append_button(button):
	action_scroll.add_child(button)

func make_buttons(actions):
	if actions:
		for action in actions:
			append_button(new_action_button(action, actions[action]))

func test_delete_first_button():
	print(action_scroll.get_child_count())
	action_scroll.get_child(0).free()

func wipe_buttons(): #shit seems to not be freeing up, on new interaction the options double?
	for child in action_scroll.get_children():
		child.free()
	print(action_scroll.get_child_count())

######## Text Scroll Button

func text_continue():
	$DialogText.scroll()
	
func text_end(): #called from a DialogText signal
	$TextHandler.disable()
	var first_action = $ActionScroll/VBoxContainer.get_child(0)
	force_focus(first_action)



### NAVIGATION

func action_down():
	pass

func action_up():
	pass

func action_confirm():
	pass
