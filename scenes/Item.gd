extends RigidBody2D

var description = "Base item object"
var pickupable = true
var player_in_self = false
var stackable = true
var icon = "res://icon.png"
var icon_highlight = "res://icon_highlight.png"
var available_actions = ["Pick up"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pick_up():
	get_parent().remove_child(self)
	return self
	
func actions():
	return available_actions
