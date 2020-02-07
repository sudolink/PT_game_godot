extends Control

const SCROLL_SPEED = 0.5

var selectables = []

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
		
func reset_visible_text():
	$DialogText/TextBox.percent_visible = 0



##### 

func interact_with_object(description,actions):
	#set textbox's text to description
	#make instantiated action buttons from the ActionButton scene, change their text
	#for action in actions:
	#action_button = ActionButton.new(buttontext, action)
	#append action button to $ActionScroll/VboxContainer
	$DialogText/TextBox.text = description
	for action in actions:
		var new_button = load("res://scenes/ActionButton.tscn").instance()
		new_button.text = action
		$ActionScroll/VBoxContainer.add_child(new_button)
	print(description, actions)
	get_parent().show_dialog()
	$TextHandler.grab_focus()


######## Text Scroll Button

func text_continue():
	$DialogText.scroll()
	
func text_end():
	var first_action = $ActionScroll/VBoxContainer.get_child(0)
	$TextHandler.end_of_text(first_action)


### NAVIGATION

func action_down():
	pass

func action_up():
	pass

func action_confirm():
	pass
