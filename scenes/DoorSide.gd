extends "res://scenes/DoorBase.gd"

export var open_to_left = false  #door opens to the left side if true
export var open_from_left = false #door can be opened only from the left side if true

func _ready():
	self.available_actions["Leave"] = funcref(self, "leave")
	self.description = "It's a left/right door."
	if self.open:
		$PreventPassage.disabled = true
	else:
		$PreventPassage.disabled = false
	if not self.open_to_left:
		self.scale = Vector2(-1,1)
		self.global_position.x += 12
	else:
		pass


func _on_interact_field_body_entered(body):
	if body.name == "Player":
		body.met_door(self)

func _on_interact_field_body_exited(body):
	if body.name == "Player":
		body.met_door(null)


func _on_obstruction_area_body_entered(body):
	if body.get("blocks_doors") != null: #If the body has the block_doors var
		if (body.global_position.x < self.global_position.x and self.open_to_left == true #also check if the obstruction is on the side that the doors open to
			or body.global_position.x > self.global_position.x and self.open_to_left == false):
				self.obstructions[body.name] = body #then add it to the door's obstructions dict

func _on_obstruction_area_body_exited(body):
	if self.obstructions.has(body.name): #if the leaving body was an obstruction, then attempt to erase it
		self.obstructions.erase(body.name)
