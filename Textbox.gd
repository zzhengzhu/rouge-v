extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $Timer

const MAX_WIDTH = 266

var text = ""
var letter_index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2
var placeholder_time = 1

signal finished_displaying()

func display_text(text_to_display : String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized #x
		await resized #y
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y / 2 + 20
	
	label.text = ""
	_display_letter()
	
func _display_letter():
	if text[letter_index] != "*":
		label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	match text[letter_index]:
		"!","?",".",",":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		"*":
			timer.start(placeholder_time)
		_:
			timer.start(letter_time)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	_display_letter()
