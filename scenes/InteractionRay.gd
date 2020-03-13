extends RayCast2D



const RAY_LENGTH = 60

var previous_object_hit = null
var parent
var ray_offset = Vector2(0,12)

var directions = {"up": Vector2(0,-RAY_LENGTH),
				"down": Vector2(0,RAY_LENGTH),
				"left": Vector2(-RAY_LENGTH,0),
				"right": Vector2(RAY_LENGTH,0),
				"upleft": Vector2(-RAY_LENGTH,-RAY_LENGTH),
				"upright": Vector2(RAY_LENGTH,-RAY_LENGTH),
				"downleft": Vector2(-RAY_LENGTH,RAY_LENGTH),
				"downright": Vector2(RAY_LENGTH,RAY_LENGTH)
				}


func _ready():
	parent = get_parent()
	position = parent.position	
	position.y = 8

func _physics_process(delta):
	update()
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(parent.global_position+ray_offset,parent.global_position+ray_offset+cast_to,[parent])
	if result:
		if result.collider.name == "TileMap":
			add_exception(result.collider)
			get_tree().call_group("interface","see_an_object","nothing")
		else:
			if previous_object_hit != result.collider and previous_object_hit != null:
				previous_object_hit.modulate.a = 1
			get_parent().met_interactable(result.collider)
			result.collider.modulate.a = 0.7
			previous_object_hit = result.collider
	else:
		if previous_object_hit:
			previous_object_hit.modulate.a = 1
		get_tree().call_group("interface","see_an_object","nothing")
		get_parent().interacting_with = null

### RAYCASTING

func direction_changed(parent_direction):
	set_cast_to(directions[parent_direction])
