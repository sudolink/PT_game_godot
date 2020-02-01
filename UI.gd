extends CanvasLayer

onready var dialog = $Dialog
onready var inventory_display = $InventoryDisplay
onready var action_dialog = $ActionSelect

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_dialog()
	toggle_inventory()
	inventory_display.set_selected_slot()
	print(inventory_display.selected_slot)
	

func _process(delta):
	catch_UI_key_presses()


func catch_UI_key_presses():
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()
		get_tree().paused = not get_tree().paused
	if inventory_display.visible:
		if Input.is_action_just_pressed("inventory_down"):
			inventory_display.inventory_down()
		if Input.is_action_just_pressed("inventory_up"):
			inventory_display.inventory_up()
		if Input.is_action_just_pressed("inventory_left"):
			inventory_display.inventory_left()
		if Input.is_action_just_pressed("inventory_right"):
			inventory_display.inventory_right()
	if action_dialog.visible:
		if Input.is_action_just_pressed("ui_left"):
			action_dialog.action_left()
		if Input.is_action_just_pressed("ui_right"):
			action_dialog.action_right()
		if Input.is_action_just_pressed("ui_accept"):
			action_dialog.action_confirm()


func hide_dialog():
	dialog.visible = false

func typeOut(text):
	$"Dialog/text".text = text
	dialog.visible = not $Dialog.visible
	
func toggle_inventory():
	inventory_display.visible = not inventory_display.visible