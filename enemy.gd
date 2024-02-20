extends Node2D

const MINSPEED = 0.2
const MAXSPEED = 3
const TIMECHANGEDIRECTION = 100
const MINDISTANCE = 100
const MAXDISTANCE = 200

var activated_statues = []
var active = false
var speed = MINSPEED
var acc = true
var directionchangecount = 0
var direction = Vector2(1, 0)
var target_direction = Vector2(1, 0)
var player
var angle

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_node("Player")
	var active = false
	visible = false
	directionchangecount = 0
	angle = 0
	direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	target_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active == true:
		angle += 1
		if angle > 360:
			angle - 360
		speed = (MAXSPEED + MINSPEED) / 2 + (MAXSPEED - MINSPEED) * sin(deg_to_rad(angle))
		
		move_randomly()
		#if speed < MAXSPEED && acc == true:
			#speed += 1
		#elif speed >= MAXSPEED:
			#acc = false
		#elif speed >= MINSPEED && acc == false:
			#speed -= 1
		#elif speed < MINSPEED:
			#acc = true
		#get_shooting_statue()
	

func move_randomly():
	var playerPoint = player.get_transform().origin
	var enemyPoint = global_position
	#var distance = (playerPoint.x - enemyPoint.x) * (playerPoint.x - enemyPoint.x) + (playerPoint.y - enemyPoint.y) * (playerPoint.y - enemyPoint.y)
	var distance = (playerPoint - enemyPoint).length()
	#print(enemyPoint.length())
	# Move the enemy in a random direction
	if directionchangecount <= 0:
		if distance < MINDISTANCE:
			target_direction = -(playerPoint - enemyPoint).normalized()
		elif distance > MAXDISTANCE:
			target_direction = (playerPoint - enemyPoint).normalized()
		else: 
			target_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
		directionchangecount = TIMECHANGEDIRECTION
	direction = (direction + (target_direction - direction) * 1 / TIMECHANGEDIRECTION)
	#direction = target_direction
	#print(direction.normalized())
	global_position = direction.normalized() * speed + global_position
	directionchangecount -= 1
	

func spawn_enemy(name):
	get_parent().get_node("Bullets").triggered = true
	get_parent().get_node("TileMap").activated = true
	active = true
	visible = true
	if name not in activated_statues:
		print(name)
		get_parent().get_node("Bullets").BULLET_COUNT += 2
		get_parent().get_node("TileMap").tilegencount += 2
		activated_statues.push_back(name)
		if activated_statues.size() == 5:
			player.berserk_mode = true
	

func get_shooting_statue():
	if activated_statues.size() > 0:
		var random_index = randi() % activated_statues.size()
		# Get the random item from the list
		var random_statue = activated_statues[random_index]
		# Print the randomly chosen item
		print("Randomly chosen statue:", random_statue)
		if random_statue == "Liberty":
			get_node("activated_statue").set_cell(0, Vector2i(0, 0), 0, Vector2i(3, 0))
		elif random_statue == "Egg Fountain":
			get_node("activated_statue").set_cell(0, Vector2i(0, 0), 0, Vector2i(3, 1))
		elif random_statue == "SLC Mouse":
			get_node("activated_statue").set_cell(0, Vector2i(0, 0), 0, Vector2i(3, 2))
		elif random_statue == "Cross":
			get_node("activated_statue").set_cell(0, Vector2i(0, 0), 0, Vector2i(3, 3))
		elif random_statue == "David":
			get_node("activated_statue").set_cell(0, Vector2i(0, 0), 0, Vector2i(3, 4))	
