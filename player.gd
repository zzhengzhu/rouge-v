extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var hitflag = false
var hitcount = 0
var berserk_mode = false

func _ready():
	berserk_mode = false
	hitflag = false
	hitcount = 0

func _physics_process(delta):
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	var direction2 = Input.get_axis("up", "down")
	velocity.x = direction * SPEED
	if direction < 0:
		get_node("AnimatedSprite2D").flip_h = true
	if direction > 0:
		get_node("AnimatedSprite2D").flip_h = false
	velocity.y = direction2 * SPEED
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info && collision_info.get_collider() != null:
		#print(collision_info.get_collider())
		#if collision_info.get_collider().collision_layer == 2:
			#var new_scene_path = "res://dead.tscn"
			#get_tree().change_scene_to_file(new_scene_path)
		#velocity = velocity.bounce(collision_info.get_normal())
		if hitcount >= 15:
			hitcount = 0
			hitflag = false
		else:
			hitcount += 1
		
		if hitflag == false || berserk_mode == true: 
			hitflag = true
			get_node("AnimatedSprite2D").play("hit")
			if collision_info.get_collider().has_method("on_tile_collided_with_player"):
				collision_info.get_collider().on_tile_collided_with_player(collision_info.get_position() + velocity.normalized())
	else:
		hitflag = false
		hitcount = 0
		get_node("AnimatedSprite2D").play("default")



func _on_area_2d_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	var new_scene_path = "res://dead.tscn"
	get_tree().change_scene_to_file(new_scene_path) # Replace with function body.

const lines : Array[String] = [
	"Bless You!"
]

func displaytext():
	DialogManager.start_dialog(get_node("Camera2D").get_node("TextPosition").global_position, lines)
