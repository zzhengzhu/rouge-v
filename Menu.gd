extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	var new_scene_path = "res://Game.tscn"
	get_tree().change_scene_to_file(new_scene_path)


func _on_quit_pressed():
	get_tree().quit()
