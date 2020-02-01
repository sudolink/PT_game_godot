extends Control

onready var container = $ItemContainer
onready var container_numbers = $ItemContainerNumbers
onready var container_squares = $ItemContainerSquares
var player_items = null
var selected_slot = 0
var previous_slot = 0
var max_slots = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	for slot in container.get_children():
		slot.texture = null
	for slot in container_squares.get_children():
		slot.visible = false

func update_inventory_contents(contents):
	player_items = contents
	update_inventory_display()

func update_inventory_display():
	for i in range(0,max_slots):
		update_inventory_slot(i)

func update_inventory_slot(slot):
	if player_items[slot].get_child_count():
		container.get_child(slot).texture = load(player_items[slot].get_child(0).icon)

func highlight():
	highlight_icon()
	highlight_square()
	previous_slot = selected_slot

func highlight_icon():
	#set selected slot's texture to corresponding item's highlight icon
	var display_slot = container.get_child(selected_slot)
	var displayed_slot = container.get_child(previous_slot)
	if not slot_empty(selected_slot):
		display_slot.texture = load(player_items[selected_slot].get_child(0).icon_highlight)
	if not slot_empty(previous_slot) and selected_slot != previous_slot:
		displayed_slot.texture = load(player_items[previous_slot].get_child(0).icon)

func highlight_square():
	var display_square = container_squares.get_child(selected_slot)
	var displayed_square = container_squares.get_child(previous_slot)
	display_square.visible = true
	display_square.get_child(0).play("pulse")
	if selected_slot != previous_slot:
		displayed_square.visible = false
		displayed_square.get_child(0).stop(true)
	
func slot_empty(slot):
	return player_items[slot].get_child_count() == 0
	

func set_selected_slot(slot = 0):
	selected_slot = slot
	highlight_square()

func inventory_down():
	if selected_slot + 5 > max_slots-1:
		selected_slot += 5 - max_slots
	else:
		selected_slot += 5
	highlight()

func inventory_up():
	if selected_slot - 5 < 0:
		selected_slot += max_slots-5
	else:
		selected_slot -= 5
	highlight()

func inventory_left():
	if selected_slot - 1 < 0:
		selected_slot = max_slots - 1
	else:
		selected_slot -= 1
	highlight()
		
func inventory_right():
	if selected_slot + 1 > max_slots -1:
		selected_slot = 0
	else:
		selected_slot += 1
	highlight()