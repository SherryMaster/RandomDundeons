@tool
extends Node2D

class_name Tile

@export_tool_button("Test Function") var show_gates: Callable = generate_boundry_walls

@onready var tile_area: Area2D = $TileArea
@onready var tile_gates: Node2D = $TileGates
@onready var tile_floor: TileMapLayer = $Floor
@onready var tile_walls: TileMapLayer = $Walls

func _ready() -> void:
	pass

func get_tile_gates() -> Array:
	print(tile_gates.get_children())
	return tile_gates.get_children()

func generate_boundry_walls() -> void:
	var tile_cords = tile_floor.get_used_cells()
	var boundry_tile_cords: Array[Vector2i] = [] # For locations of the boundry tiles
	var boundry_tile_path: Array[Vector2i] = [] # For traversing the boundry tiles
	var wall_cords: Array[Vector2i] = []


	
	# # For each tile, check if it's on the boundary
	for tile in tile_cords:
		# Check all 8 neighboring positions
		var neighbors = [
			Vector2i(1, 0),   # right
			Vector2i(-1, 0),  # left
			Vector2i(0, 1),   # bottom
			Vector2i(0, -1),  # top
			Vector2i(1, 1),   # bottom-right
			Vector2i(-1, 1),  # bottom-left
			Vector2i(1, -1),  # top-right
			Vector2i(-1, -1)  # top-left
		]
		
		# If any neighboring position is empty, this is a boundary tile
		for neighbor in neighbors:
			var check_pos = tile + neighbor
			if not tile_floor.get_cell_tile_data(check_pos):
				boundry_tile_cords.append(tile)
				break
	
	### Traverse through the boundry tiles manually
	var lowest_y = 0
	var lowest_x = 0

	for tile in tile_cords:
		if tile.x < lowest_x:
			lowest_x = tile.x
		if tile.y < lowest_y:
			lowest_y = tile.y
	
	var current_cords = Vector2i(lowest_x, lowest_y)

	# get to the first valid tile
	while current_cords not in boundry_tile_cords:
		current_cords.x += 1
	
	boundry_tile_path.append(current_cords)

	var MAX_LOOP = 10000

	while MAX_LOOP:
		var neighbors = [
			Vector2i(0, -1),  # top
			Vector2i(1, 0),   # right
			Vector2i(0, 1),   # bottom
			Vector2i(-1, 0),  # left
		]

		for neighbor in neighbors:
			var check_pos = current_cords + neighbor
			if check_pos in boundry_tile_cords and check_pos not in boundry_tile_path:
				boundry_tile_path.append(check_pos)
				current_cords = check_pos
				break
		
	
	# Clear existing walls
	tile_walls.clear()
	
	# Calculate size difference for proper wall placement
	var size_diff: Vector2 = tile_floor.tile_set.tile_size - (tile_walls.tile_set.tile_size - tile_walls.tile_set.tile_size / 2)
	
	# Place walls on boundary tiles
	
	var current_placing_direction = Vector2.RIGHT

	for tile in boundry_tile_cords:
		var top_left = tile_walls.local_to_map(tile_floor.map_to_local(tile) - size_diff / 2)
		var top_right = tile_walls.local_to_map(Vector2((tile_floor.map_to_local(tile) + size_diff / 2).x, (tile_floor.map_to_local(tile) - size_diff / 2).y))
		var bottom_left = tile_walls.local_to_map(Vector2((tile_floor.map_to_local(tile) - size_diff / 2).x, (tile_floor.map_to_local(tile) + size_diff / 2).y))
		var bottom_right = tile_walls.local_to_map(tile_floor.map_to_local(tile) + size_diff / 2)

		if current_placing_direction == Vector2.RIGHT:
			wall_cords.append(top_left)
		elif current_placing_direction == Vector2.DOWN:
			wall_cords.append(top_right)
		elif current_placing_direction == Vector2.LEFT:
			wall_cords.append(bottom_right)
		elif current_placing_direction == Vector2.UP:
			wall_cords.append(bottom_left)

		tile_walls.set_cell(
			top_left, 
			0, 
			Vector2i(0, 0)
		)


func generate_wall(start: Vector2i, end: Vector2i) -> void:
	var cords_arr: Array[Vector2i] = []

	var x_is_large = end.x > start.x;
	var y_is_large = end.y > start.y;

	var x_diff = end.x - start.x if x_is_large else start.x - end.x
	var y_diff = end.y - start.y if y_is_large else start.y - end.y

	if x_diff < y_diff:
		while start.y != end.y:
			if y_is_large:
				start.y += 1
			else:
				start.y -= 1
			cords_arr.append(start)

		while start.x != end.x:
			if x_is_large:
				start.x += 1
			else:
				start.x -= 1
			cords_arr.append(start)
	
	if x_diff > y_diff:
		while start.x != end.x:
			if x_is_large:
				start.x += 1
			else:
				start.x -= 1
			cords_arr.append(start)
		while start.y != end.y:
			if y_is_large:
				start.y += 1
			else:
				start.y -= 1
			cords_arr.append(start)

	
	tile_walls.set_cells_terrain_connect(cords_arr, 0, 0)



