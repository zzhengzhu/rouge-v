extends Node


@onready var text_box_scene = preload("res://Textbox.tscn")

var dialog_lines : Array[String] = []
var index = 0

var textbox
var textboxposition

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position : Vector2, lines : Array[String]):
	if is_dialog_active == true:
		return
	
	dialog_lines = lines
	textboxposition = position
	_show_text_box()
	
	is_dialog_active = true

func _show_text_box():
	textbox = text_box_scene.instantiate()
	textbox.finished_displaying.connect(_on_textbox_finish_displaying)
	get_tree().root.add_child(textbox)
	textbox.global_position = textboxposition
	textbox.display_text(dialog_lines[index])
	can_advance_line = false
	
func _on_textbox_finish_displaying():
	can_advance_line = true
	
	
func _process(delta):
	if (
		is_dialog_active &&
		can_advance_line
	):
		textbox.queue_free()
		index += 1 
		if index >= dialog_lines.size():
			is_dialog_active = false
			index = 0
			return
		
		_show_text_box()
	
