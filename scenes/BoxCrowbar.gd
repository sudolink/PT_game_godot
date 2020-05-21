extends "res://Box.gd"

var crowbar_taken = false

onready var crowbar_taken_sprite = "res://assets/objects/BoxCrowbarEmpty.png"
onready var sprite_texture = $Sprite
onready var crowbar = load("res://scenes/Crowbar.tscn")

func _ready():
	self.description = "It's a wooden box. There's a crowbar sticking out."
	self.available_actions["Take Crowbar"] = funcref(self, "take_contents")
	self.contents.append(crowbar.instance())
	
func open():
	#if has key_id or crowbar
	print("open attempt")

func drag():
	print("drag attempt")
	
#func set_player(player_obj):
#	self.player = player_obj

func take_contents():
	self.available_actions.erase("Take Crowbar")
	self.description = "It's a wooden box."
	sprite_texture.texture = load(crowbar_taken_sprite)
	get_tree().call_group("player_inventory","add_to_inventory",contents[0])
	only_leave_left()
