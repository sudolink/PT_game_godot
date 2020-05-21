extends TextureButton


var long_text_texture = load("res://assets/hud/text_next.png")
var end_text_texture = load("res://assets/hud/text_end.png")


func play_pulse():
	$animation.play("pulsing")

func stop_and_reset_pulse():
	$animation.stop()
	$animation.seek(0,true)

func _on_Triangle_focus_entered():
	if not self.disabled:
		play_pulse()

func _on_Triangle_focus_exited():
	stop_and_reset_pulse()

func _on_Triangle_pressed():
	print("text_continue pressed")
	get_tree().call_group("dialog","text_continue")

func set_up():
	#IF TEXT IS LONG ENOUGH, SET TEXTURE AND PLAY PULSE
	self.texture_normal = long_text_texture
	play_pulse()
	#ELSE DISABLE AND SET TEXTURE TO END
	
func disable():
	self.texture_normal = end_text_texture
	stop_and_reset_pulse()
	self.set_focus_mode(0)#cannot be focused

func enable():
	self.texture_normal = long_text_texture
	play_pulse()
	self.set_focus_mode(2)#both keyboard an mouse

func reset_state():
	#set_up() #should check how long the text is, and set disabled/enabled state to button
	pass
