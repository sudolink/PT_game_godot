extends "res://scenes/DoorBase.gd"

export var open_upward = false
export var open_from_above = false

func _ready():
	self.available_actions["Leave"] = funcref(self, "leave")
	self.description = "It's a down/up door"
	
	if self.open_upward == true:
		$Doors_Up.name = "AnimationHandler"
	else:
		$Doors_Down.name ="AnimationHandler"


func _on_interact_field_body_entered(body):
	if body.name == "Player":
		body.met_door(self)

func _on_interact_field_body_exited(body):
	if body.name == "Player":
		body.met_door(null)

func _on_LowerRender_body_entered(body):
	if body.name == "Player":
		z_index = -10
		
func _on_UpperRender_body_entered(body):
	if body.name == "Player":
		z_index = 10


func _on_obstruction_area_body_entered(body):
	if body.get("blocks_doors") != null: #If the body has the block_doors var
		if (body.global_position.y < self.global_position.y and self.open_upward == true #also check if the obstruction is on the side that the doors open to
			or body.global_position.y > self.global_position.y and self.open_upward == false):
				self.obstructions[body.name] = body #then add it to the door's obstructions dict

func _on_obstruction_area_body_exited(body):
	if self.obstructions.has(body.name):
		self.obstructions.erase(body.name)
