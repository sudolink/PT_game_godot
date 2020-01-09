extends StaticBody2D


var highlighted = load("res://assets/objects/Box_select.png")
var idle = load("res://assets/objects/Box_idle.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_proximity_body_entered(body):
	if body.name == "Player":
		$Sprite.texture = highlighted
		body.iminside()



func _on_proximity_body_exited(body):
	if body.name == "Player":
		$Sprite.texture = idle
		body.ileft()
