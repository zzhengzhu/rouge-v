extends TileMap

const SPAWN_INTERVAL = 100

var tileset : TileSet
var activated = false
var tilegencount = 10
var player
var timer = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	tileset = get_tileset()
	activated = false
	tilegencount = 5
	timer = 0
	player = get_parent().get_parent().get_node("Player")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated == true:
		if timer >= SPAWN_INTERVAL:
			timer -= SPAWN_INTERVAL
			spawn()
		timer += 1

func on_tile_collided_with_player(position):
	#print(position)
	var cell_position = local_to_map(to_local(position)) 
	#print(cell_position)
	var cell_source_id = get_cell_source_id(0, cell_position)
	if cell_source_id == -1:
		cell_position.y -= 1
		cell_source_id = get_cell_source_id(0, cell_position)
	
	var atlas_coord = get_cell_atlas_coords(0, cell_position)
	#var data = get_cell_tile_data(0, cell_position)
	#print(atlas_coord)
	#print(cell_source_id)
	
	var cell_set_source = tileset.get_source(cell_source_id)
	if atlas_coord.y == 8:
		var new_scene_path = "res://winning.tscn"
		get_tree().change_scene_to_file(new_scene_path)
		
	if cell_source_id == 0:
		set_cell(0, cell_position, cell_source_id, Vector2i(atlas_coord.x + 1, atlas_coord.y))
	
func spawn():
	var cell_position = local_to_map(to_local(player.get_transform().origin))
	 
	for i in tilegencount:
		var tileIndex = randi_range(0, 7)
		var spawn_position = cell_position
		
		var x_offset = randi_range(-10, 10)
		while x_offset > -2 and x_offset < 2:
			x_offset = randi_range(-10, 10)
		
		var y_offset = randi_range(-10, 10)
		while y_offset > -2 and y_offset < 2:
			y_offset = randi_range(-10, 10)
		spawn_position.x += x_offset
		spawn_position.y += y_offset
		
		set_cell(0, spawn_position, 0, Vector2i(0, tileIndex))
	
	if player.berserk_mode == true:
		var luck = randi_range(-5, 5)
		if luck == 0:
			var spawn_position = cell_position
			var x_offset = randi_range(-10, 10)
			while x_offset > -2 and x_offset < 2:
				x_offset = randi_range(-10, 10)
			
			var y_offset = randi_range(-10, 10)
			while y_offset > -2 and y_offset < 2:
				y_offset = randi_range(-10, 10)
			spawn_position.x += x_offset
			spawn_position.y += y_offset
			print(spawn_position)
			set_cell(0, spawn_position, 0, Vector2i(0, 8))
