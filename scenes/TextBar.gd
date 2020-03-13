extends Control

var run_fade = false
var elapsed = 0
var wait_end = 2

func _process(delta):
	if run_fade:
		if elapsed >= wait_end:
			if self.modulate.a > 0:
				self.modulate.a -= delta * 30
			else:
				get_tree().call_group("interface","hide_text_bar")
		elapsed += wait_end
	

func reset_fade():
	self.modulate.a = 100
	elapsed = 0
	run_fade = false

func set_text(text):
	$TextureRect/Label.text = text
	run_fade = true
