extends CanvasLayer

onready var dialog = $Dialog
onready var inventory_display = $InventoryDisplay
onready var action_dialog = $ActionSelect
onready var text_bar = $TextBar

var last_object_seen = null

# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_inventory()
	hide_dialog()
	hide_text_bar()
	inventory_display.set_selected_slot()
	self.layer = 1
	

func _process(delta):
	catch_UI_key_presses()


func catch_UI_key_presses():
	if Input.is_action_just_pressed("inventory") and not dialog.visible:
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
	if dialog.visible:
		if Input.is_action_just_pressed("ui_down"):
			dialog.action_down()
		if Input.is_action_just_pressed("ui_up"):
			dialog.action_up()
		if Input.is_action_just_pressed("ui_accept"):
			dialog.action_confirm()

func see_an_object(object):
	if typeof(object) == typeof("nothing"):
		last_object_seen = self #set the last object to self - a quick workaround for the TextBox to
		hide_text_bar()			#show up when the player looks at the same object twice in a row
	else:
		if not object == last_object_seen:
			text_bar.reset_fade()
			last_object_seen = object
			text_bar.set_text(object.name)
			show_text_bar()
	
	
func hide_text_bar():
	text_bar.visible = false
	text_bar.reset_fade()
	
func show_text_bar():
	text_bar.visible = true
	
func toggle_inventory():
	inventory_display.visible = not inventory_display.visible
	$DarkenBackground.visible = not $DarkenBackground.visible

func show_dialog():
	$DarkenBackground.visible = true
	get_tree().paused = true
	dialog.visible = true

func hide_dialog():
	$DarkenBackground.visible = false
	get_tree().paused = false
	dialog.visible = false
	dialog.reset()
