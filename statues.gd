extends TileMap

var tileset : TileSet

const lines_liberty : Array[String] = [
	"You angered the godness of liberty*",
	"by setting her free!*"
]

const lines_egg : Array[String] = [
	"You broke the seal of Egg Fountain!*",
	"Revenge incoming...*"
]

const lines_mouse : Array[String] = [
	"You killed a mouse living peacefully*",
	"in SLC Tim Hortons*"
]

const lines_cross : Array[String] = [
	"You have awoken the undead.*",
	"They will haunt you forever.*"
]

const lines_david : Array[String] = [
	"David has collpased.*",
	"You owe lots of money now.*"
]



@onready var player = get_parent().get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	tileset = get_tileset()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_tile_collided_with_player(position):
	#DialogManager.start_dialog(position, lines)
	#print(position)
	var cell_position = local_to_map(to_local(position)) 
	#print(cell_position)
	var cell_source_id = get_cell_source_id(0, cell_position)
	var atlas_coord = get_cell_atlas_coords(0, cell_position)
	#var data = get_cell_tile_data(0, cell_position)
	#print(atlas_coord)
	#print(cell_source_id)
	
	var cell_set_source = tileset.get_source(cell_source_id)
	if atlas_coord.x == 3:
		print("collapsed")
		if atlas_coord.y == 0:
			get_parent().get_node("enemy").spawn_enemy("Liberty")
			var lines = lines_liberty.duplicate()
			var str : String = "Statues left: " + String.chr(48 + 5 - get_parent().get_node("enemy").activated_statues.size()) + "**"
			lines.push_back(str)
			DialogManager.start_dialog(position, lines)
			#activated_statues.size()
		if atlas_coord.y == 1:
			get_parent().get_node("enemy").spawn_enemy("Egg Fountain")
			var lines = lines_egg.duplicate()
			var str : String = "Statues left: " + String.chr(48 + 5 - get_parent().get_node("enemy").activated_statues.size()) + "**"
			lines.push_back(str)
			DialogManager.start_dialog(position, lines)
		if atlas_coord.y == 2:
			get_parent().get_node("enemy").spawn_enemy("SLC Mouse")	
			var lines = lines_mouse.duplicate()
			var str : String = "Statues left: " + String.chr(48 + 5 - get_parent().get_node("enemy").activated_statues.size()) + "**"
			lines.push_back(str)
			DialogManager.start_dialog(position, lines)
		if atlas_coord.y == 3:
			get_parent().get_node("enemy").spawn_enemy("Cross")
			var lines = lines_cross.duplicate()
			var str : String = "Statues left: " + String.chr(48 + 5 - get_parent().get_node("enemy").activated_statues.size()) + "**"
			lines.push_back(str)
			DialogManager.start_dialog(position, lines)
		if atlas_coord.y == 4:
			get_parent().get_node("enemy").spawn_enemy("David")
			var lines = lines_david.duplicate()
			var str : String = "Statues left: " + String.chr(48 + 5 - get_parent().get_node("enemy").activated_statues.size()) + "**"
			lines.push_back(str)
			DialogManager.start_dialog(position, lines)
			
	if cell_source_id == 0:
		set_cell(0, cell_position, cell_source_id, Vector2i(atlas_coord.x + 1, atlas_coord.y))
	
