extends "res://Box.gd"

var crowbar_taken = false

onready var crowbar_taken_sprite = "res://assets/objects/BoxCrowbarEmpty.png"


func _ready():
	self.description = "It's a wooden box. There's a crowbar sticking out."
	self.available_actions.push_front("Take Crowbar")
	var crowbar = load("res://scenes/Crowbar.gd")
	self.contents.append(crowbar.new())
	
func open():
	#if has key_id or crowbar
	print("open attempt")

func drag():
	print("drag attempt")

func take_contents():
	print("loot attempt")
