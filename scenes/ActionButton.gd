extends Control


var execute = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# init apparently must be called if defined - otherwise none of the signals or functions work!
#func _init(text,actions):
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_up(button_text, function):
	print(button_text,function)
	self.text = button_text
	execute = function
	
func do_action():
	execute.call_func()


func _on_ActionButton_pressed():
	#toggle UI?
	do_action()
	get_tree().call_group("dialog","action_taken",self)


func _on_ActionButton_focus_entered():
	$highlight.play("slide_in")
	
func _on_ActionButton_focus_exited():
	$highlight.play("slide_out")
