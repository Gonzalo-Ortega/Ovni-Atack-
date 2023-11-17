extends TileMap

var House = preload("res://scenes/house.tscn")
var Human = preload("res://scenes/human.tscn")

var chunk_size = Vector2i(32, 13)
var used_grid = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var tiles_dict = {
	"empty": Vector2i(1, 0),
	"navigation_obstacle": Vector2i(3,0),
	"tree1": Vector2i(0,0),
	"tree2": Vector2i(3,1),
	"road_up": Vector2i(4, 0),
	"road_side": Vector2i(5, 1),
	"road_up_left": Vector2i(2,1),
	"road_up_right": Vector2i(2,0),
	"road_down_left": Vector2i(1,1),
	"road_down_right": Vector2i(0,1)
}


func _get_chunk_group_name(chunk):
	return "entities_in_chunk_"+str(chunk)


func _spawn_house(position):
	var house = House.instantiate()
	house.position = position
	house.add_to_group(_get_chunk_group_name(last_chunk_position))
	$Entities.add_child(house)


func _spawn_human(position):
	var human = Human.instantiate()
	human.position = position
	human.add_to_group(_get_chunk_group_name(last_chunk_position))
	$Entities.add_child(human)


func _generate_houses(tile_pos):
	var house_size = Vector2i(3, 3) # House grid size
	var house_pattern = [
		Vector2i(0,0), Vector2i(0, 1), Vector2i(0, 2),
		Vector2i(1,0), Vector2i(1, 1), Vector2i(1, 2),
		Vector2i(2,0), Vector2i(2, 1), Vector2i(2, 2),
	]
	var num_of_houses = randi_range(0, 10) # TODO extract to a resource
	for i in range(num_of_houses):
		var house_pos = Vector2i(randi_range(0, chunk_size.x-house_size.x), randi_range(0, chunk_size.y-house_size.y))
		var collision = false
		for vec in house_pattern:
				collision = collision or used_grid[vec.x+house_pos.x][vec.y+house_pos.y]
		if not collision:
			for vec in house_pattern:
					var grid_pos = house_pos+vec
					used_grid[grid_pos.x][grid_pos.y] = true
					set_cell(0, tile_pos+grid_pos, 0, tiles_dict["navigation_obstacle"])
			var house_spawn_pos = map_to_local(house_pos+tile_pos)
			_spawn_house(house_spawn_pos)

var last_road_exit = randi_range(0, chunk_size.y)


func _generate_road(tile_pos):
	var current_entry = last_road_exit
	var last_up = 0
	for x in range(chunk_size.x):
		if abs(current_entry-(chunk_size.y/2)) > chunk_size.y*0.6:
			current_entry = -2
		var upto = current_entry+randi_range(-4, 4)
		if randi_range(0, 10) > 7 and last_up > 2 and upto-current_entry > 1:
			for t_y in range(abs(upto-current_entry)+1):
				var y = current_entry+t_y*sign(upto-current_entry)
				var tile_to_use = "road_up"
				if t_y == 0:
					if sign(upto-current_entry) == 1:
						tile_to_use = "road_up_left"
					else:
						tile_to_use = "road_down_left"
				if t_y == abs(upto-current_entry):
					if sign(upto-current_entry) == 1:
						tile_to_use = "road_down_right"
					else:
						tile_to_use = "road_up_right"
				if y >= 0 and y < chunk_size.y:
					set_cell(0, tile_pos+Vector2i(x, y), 0, tiles_dict[tile_to_use])
					used_grid[x][y] = true
			last_up = 0
			current_entry = upto
		else:
			if current_entry >= 0 and current_entry < chunk_size.y:
				set_cell(0, tile_pos+Vector2i(x, current_entry), 0, tiles_dict["road_side"])
				used_grid[x][current_entry] = true
			last_up += 1
	last_road_exit = current_entry


func _generate_humans(tile_pos):
	var humans = randi_range(4, 10)
	for i in humans:
		var human_pos = Vector2i(randi_range(0, chunk_size.x-1), randi_range(0, chunk_size.y-1))
		if not used_grid[human_pos.x][human_pos.y]:
			var human_spawn_pos = map_to_local(human_pos+tile_pos)
			_spawn_human(human_spawn_pos)


func _clear_user_grid():
	used_grid = []
	for i in range(chunk_size.x):
		var column = []
		for j in range(chunk_size.y):
			column.append(false)
		used_grid.append(column)

var last_chunk_position = -1
func update_map_for_position(position):
	var tile_pos = local_to_map(position)
	var current_chunk = int((tile_pos.x+chunk_size.x/2) / chunk_size.x)
	if current_chunk > last_chunk_position:
		last_chunk_position += 1
		generate_chunk(Vector2i(chunk_size.x*current_chunk, 0))


func _fill_with_blank(tile_pos):
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			set_cell(0, tile_pos+Vector2i(x, y), 0, tiles_dict["empty"])


func generate_chunk(tile_pos):
	# Remove all entities in old chunks
	get_tree().call_group(_get_chunk_group_name(last_chunk_position-3), "queue_free")
	
	_clear_user_grid()
	
	_fill_with_blank(tile_pos)
	_generate_road(tile_pos)
	_generate_houses(tile_pos)
	_generate_humans(tile_pos)
