extends ScrollContainer

var current_scroll = null
var previous_scroll = null
const SCROLL_VALUE = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scroll = 0
	previous_scroll = 0
	print("last line number: ",get_last_line_number()," --printing from DialogText.gd")

func scroll():
	#scroll_to_line
	self.get_v_scrollbar().value += SCROLL_VALUE
	current_scroll = get_v_scrollbar().value
	previous_scroll += SCROLL_VALUE
	if previous_scroll > current_scroll:
		get_tree().call_group("dialog","text_end")

func get_last_line_number():
	return $TextBox.text.split("\n").size()

func set_text(text):
	self.text = text
	if get_last_line_number() > 3:
		print("\n Lines in description > 3: ", get_last_line_number())

func reset():
	$TextBox.percent_visible = 0
	reset_scroll()

func reset_scroll():
	current_scroll = 0
	previous_scroll = 0
	get_v_scrollbar().value = current_scroll
	
