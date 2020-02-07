extends Node2D

var max_size
var slot_nodes
var ui
############## INVENTORY ##################
signal inventory_change

func _ready():
	max_size = get_child_count()
	slot_nodes = get_children()
	get_tree().call_group("inventory_display","update_inventory_contents",get_children())
	
func add_to_inventory(item):
	for slot in slot_nodes:
		if slot.get_child_count() == 0:
			slot.add_child(item)
			print("Picked up %s, now in slot %s." % [item.name,slot.name])
			get_tree().call_group("inventory_display","update_inventory_contents",get_children())
			break
