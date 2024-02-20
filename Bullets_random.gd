extends Node2D
# This demo is an example of controling a high number of 2D objects with logic
# and collision without using nodes in the scene. This technique is a lot more
# efficient than using instancing and nodes, but requires more programming and
# is less visual. Bullets are managed together in the `bullets.gd` script.

const BULLET_COUNT = 12
const SPEED_MIN = 50
const SPEED_MAX = 500
const ANGLE_INCREMENT = 30
const LIFE_TIME = 100

const bullet_image = preload("res://assets/bullet/bullet1.png")

var bullets = []
var shape



class Bullet:
	var position = Vector2.ZERO
	var speed = 0
	var speedX = 0
	var speedY = 0
	var direction = 0
	var lifeTime = LIFE_TIME
	# The body is stored as a RID, which is an "opaque" way to access resources.
	# With large amounts of objects (thousands or more), it can be significantly
	# faster to use RIDs compared to a high-level approach.
	var body = RID()


func _ready():
	randomize()

	shape = PhysicsServer2D.circle_shape_create()
	# Set the collision shape's radius for each bullet in pixels.
	PhysicsServer2D.shape_set_data(shape, 6)

	var angle_i = 0
	for i in BULLET_COUNT:
		var bullet = Bullet.new()
		# Give each bullet its own speed.
		var angle_point = deg_to_rad(angle_i)
		bullet.direction = angle_point
		bullet.speed = randf_range(SPEED_MIN, SPEED_MAX)
		bullet.speedX = bullet.speed * sin(angle_point)
		bullet.speedY = bullet.speed * cos(angle_point)
		bullet.lifeTime = LIFE_TIME + angle_i
		
		bullet.body = PhysicsServer2D.body_create()

		PhysicsServer2D.body_set_space(bullet.body, get_world_2d().space)
		PhysicsServer2D.body_add_shape(bullet.body, shape)

		# Place bullets randomly on the viewport and move bullets outside the
		# play area so that they fade in nicely.
		bullet.position = Vector2(-1000,0)
		var transform2d = Transform2D()
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
		PhysicsServer2D.body_set_collision_layer(bullet.body, 2)
		PhysicsServer2D.body_set_collision_layer(bullet.body, 2)
		
		angle_i = (angle_i + ANGLE_INCREMENT) % 360

		bullets.push_back(bullet)


func _process(delta):
	var transform2d = Transform2D()

	for bullet in bullets:
		bullet.position.x += bullet.speedX * delta
		bullet.position.y += bullet.speedY * delta
		#if bullet.position.x < -100 or bullet.position.x > 1600 or bullet.position.y < -100 or bullet.position.y > 1000:
		if bullet.lifeTime <= 0:
			# The bullet has dead; move it back.
			bullet.position = get_parent().get_parent().get_node("Player").get_transform().origin
			bullet.speed = randf_range(SPEED_MIN, SPEED_MAX)
			bullet.speedX = bullet.speed * sin(bullet.direction)
			bullet.speedY = bullet.speed * cos(bullet.direction)
			bullet.lifeTime = LIFE_TIME

		transform2d.origin = bullet.position
		bullet.lifeTime -= 1
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
		
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

	PhysicsServer2D.free_rid(shape)
	bullets.clear()
