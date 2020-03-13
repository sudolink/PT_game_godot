extends StaticBody2D


export(bool) var locked = true
export(bool) var has_key = false
export(bool) var allow_crowbar = true
export(bool) var alternate_door_open = false
var player = null

var contents = ["txt placeholder","fleshlight","anal beads"] 
var available_actions = {}
var closed_description = "It's an old locker."
var description = closed_description
var opened_description = "An old locker. \nContents: \n{str}"

func _ready():
	self.available_actions["Open"] = funcref(self,"attempt_open")
	
func set_player(player):
	self.player = player

func actions():
	return available_actions	

func attempt_open():
	if locked:
		self.description += "\nIt's locked" #add a new line to description
		if self.has_key:
			print("needs key")
		if self.allow_crowbar:
			self.available_actions.erase("Open") #remove the open option
			self.available_actions["Pry it open"] = funcref(self,"crowbar_it")
	else:
		open()

func crowbar_it():
	#if crowbar present
	if player.has_crowbar():
		if self.alternate_door_open:
			$AnimationHandler.play("CrowbarItAlt")
		else:
			$AnimationHandler.play("CrowbarIt")
		var grab_contents = contents if len(self.contents) > 0 else "Empty"
		self.description = self.opened_description.format({"str" : grab_contents})
		self.available_actions.erase("Pry it open")
		for 
		self.available_actions["Close"] = funcref(self,"close")
	else:
		self.description += "\nI can't pry it open with my fingers"
	
func open():
	if self.alternate_door_open:
		$AnimationHandler.play("OpenItAlt")
	else:
		$AnimationHandler.play("OpenIt")
	self.description = self.opened_description % (contents if len(contents) > 0 else "Empty")
	self.available_actions["Close"] = funcref(self,"close")

func close():
	if self.alternate_door_open:
		$AnimationHandler.play("CloseItAlt")
	else:
		$AnimationHandler.play("CloseIt")
	self.description = self.closed_description


func take_item(item):
	pass

#func open(player):
#	if not open:
#		if locked:
#			if player.has_crowbar():
#				print("crowbar the motherfucker")
#				open = true
#				$AnimationHandler.play("CrowbarIt")
#			else:
#				print("You'd need a crowbar. Or something.")
#		else:
#			print("open the locker")
#			$AnimationHandler.play("OpenIt")
#			open = true
#	else:
#		if $AnimationHandler.current_animation == "CrowbarIt":
#			print("Can't close'")
#		else:
#			$AnimationHandler.play("CloseIt")
	
