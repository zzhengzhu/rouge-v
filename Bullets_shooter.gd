extends Node2D
# This demo is an example of controling a high number of 2D objects with logic
# and collision without using nodes in the scene. This technique is a lot more
# efficient than using instancing and nodes, but requires more programming and
# is less visual. Bullets are managed together in the `bullets.gd` script.

const BULLET_COUNT = 12
const SPEED_MIN = 100
const SPEED_MAX = 100
const ANGLE_RANGE = 30
const LIFE_TIME = 200
const SPAWN_DELAY = 15

const bullet_image = preload("res://assets/bullet/bullet1.png")

var bullets = []
var alive_count = 0
var elapse = 0
var shooting = false
var shape



class Bullet:
	var position = Vector2.ZERO
	var spawned = false
	var alive = false
	var speed = 0
	var speedX = 0
	var speedY = 0
	var direction = Vector2(0,0)
	var lifeTime = LIFE_TIME
	# The body is stored as a RID, which is an "opaque" way to access resources.
	# With large amounts of objects (thousands or more), it can be significantly
	# faster to use RIDs compared to a high-level approach.
	var body = RID()


func _ready():
	randomize()

func on_bullet_spawned():
	shape = PhysicsServer2D.circle_shape_create()
	# Set the collision shape's radius for each bullet in pixels.
	PhysicsServer2D.shape_set_data(shape, 6)
	var PLAYER = get_parent().get_node("Player")
	alive_count = BULLET_COUNT
	for i in BULLET_COUNT:
		var bullet = Bullet.new()
		bullet.position = Vector2(-1000,0)
		#bullet.position = PLAYER.get_transform().origin
		bullet.direction = (get_global_mouse_position() - PLAYER.get_transform().origin).normalized()
		var range = deg_to_rad(randf_range(-ANGLE_RANGE, ANGLE_RANGE))
		var newDirection = Vector2(0,0)
		newDirection.x = cos(range) * bullet.direction.x - sin(range) * bullet.direction.y
		newDirection.y = sin(range) * bullet.direction.x + cos(range) * bullet.direction.y
		bullet.direction = newDirection
		bullet.speed = randf_range(SPEED_MIN, SPEED_MAX)
		bullet.speedX = bullet.speed * bullet.direction.x
		bullet.speedY = bullet.speed * bullet.direction.y
		bullet.lifeTime = 0 + SPAWN_DELAY * i
		bullet.spawned = false
		bullet.alive = true
		
		bullet.body = PhysicsServer2D.body_create()

		PhysicsServer2D.body_set_space(bullet.body, get_world_2d().space)
		PhysicsServer2D.body_add_shape(bullet.body, shape)

		# Place bullets randomly on the viewport and move bullets outside the
		# play area so that they fade in nicely.
		var transform2d = Transform2D()
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
		PhysicsServer2D.body_set_collision_layer(bullet.body, 2)
		PhysicsServer2D.body_set_collision_layer(bullet.body, 2)
		
		bullets.push_back(bullet)

func _process(delta):
	var transform2d = Transform2D()
	if Input.is_action_just_pressed("lmb") && shooting == false:
		on_bullet_spawned()
		shooting = true
	if shooting == true:
		for bullet in bullets:
			if bullet.alive == true:
				bullet.position.x += bullet.speedX * delta
				bullet.position.y += bullet.speedY * delta
				transform2d.origin = bullet.position
				bullet.lifeTime -= 1
				PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
				#if bullet.position.x < -100 or bullet.position.x > 1600 or bullet.position.y < -100 or bullet.position.y > 1000:
				if bullet.lifeTime <= 0:
					if bullet.spawned == false:
						bullet.spawned = true
						bullet.position = get_parent().get_node("Player").get_transform().origin
						bullet.speed = randf_range(SPEED_MIN, SPEED_MAX)
						bullet.speedX = bullet.speed * bullet.direction.x
						bullet.speedY = bullet.speed * bullet.direction.y
						bullet.lifeTime = LIFE_TIME
					else:
						bullet.alive = false
						bullet.position = Vector2(-1000,0)
						PhysicsServer2D.free_rid(bullet.body)
						alive_count -= 1
	
	if alive_count <= 0 && shooting == true:
		shooting = false
		PhysicsServer2D.free_rid(shape)
		bullets.clear()
	# Order the CanvasItem to update since bullets are moving every frame.
	queue_redraw()


# Instead of drawing each bullet individually in a script attached to each bullet,
# we are drawing *all* the bullets at once here.
func _draw():
	var offset = -bullet_image.get_size() * 0.5
	for bullet in bullets:
		draw_texture(bullet_image, bullet.position + offset)


# Perform cleanup operations (required to exit without error messages in the console).
func _exit_tree():
	for bullet in bullets:
		PhysicsServer2D.free_rid(bullet.body)

	if shape:
		PhysicsServer2D.free_rid(shape)
	bullets.clear()
