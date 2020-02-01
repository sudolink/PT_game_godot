extends "res://Box.gd"

var crowbar_taken = false
var available_actions = ["take_contents","drag","open"]
onready var crowbar_taken_sprite = "res://assets/objects/BoxCrowbarEmpty.png"


func _ready():
	self.description = "It's a wooden box. There's a crowbar sticking out."
	var crowbar = load("res://scenes/Crowbar.gd")
	self.contents.append(crowbar.new())
	
func use():
	print("take crowbar, drag box, crowbar box open")
	get_tree().call_group("action_select_dialog","display_actions", available_actions)

func open():
	#if has key_id or crowbar
	print("open attempt")

func drag():
	print("drag attempt")

func take_contents():
	print("loot attempt")