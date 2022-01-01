extends TileMap

export var tileset_index:int = 0

func duplicate_map() -> TileMap:
	var new_map:TileMap = TileMap.new()
	new_map.tile_set = tile_set
	new_map.cell_size = cell_size
	add_child(new_map)
	return new_map

func slide_set_cells(coords:Array) -> void:
	# [ { from = Vector2, to = Vector2, tile = Vector2 }, ]
	for cell in coords:
		# Set the cell on the real map to find the correct autotile coords
		set_cell(cell.to.x, cell.to.y, tileset_index)
		
	update_bitmask_region()
	
	for cell in coords:
		cell.tile = get_cell_autotile_coord(cell.to.x, cell.to.y)
		# Remove the cell so it doesn't show before animating
		set_cell(cell.to.x, cell.to.y, -1)
		
		# Create a cell on the overlay map
		var cell_map:TileMap = duplicate_map()
		cell_map.set_cell(cell.to.x, cell.to.y, tileset_index, false, false, false, cell.tile)
		
		var delta:Vector2 = cell.to - cell.from
		if delta.x < -1:
			delta.x = -1
		elif delta.x > 1:
			delta.x = 1
		if delta.y < -1:
			delta.y = -1
		elif delta.y > 1:
			delta.y = 1
		
		# Animate the overlay to slide from the old tile position to the new tile position
		cell_map.position = - cell_map.cell_size * delta
		cell_map.modulate.a = 0
		
	for map in get_children():
		if map is TileMap:
#			yield(Timers.wait(0.15), "completed")
			map.modulate.a = 1
			Tweens.tween(map, "position", map.position, Vector2(0, 0), 0.15)
	
	yield(Timers.wait(0.25), "completed")
	for map in get_children():
		if map is TileMap:
			map.queue_free()
		
	for cell in coords:
		# Remove the cell from the overlay map
#		$Overlay.set_cell(cell.to.x, cell.to.y, -1)
		# Add the cell back to the real map
		set_cell(cell.to.x, cell.to.y, tileset_index)
		
	update_bitmask_region()

func slide_erase_cells(coords:Array) -> void:
	# [ { from = Vector2, to = Vector2, tile = Vector2 }, ]
	
	for cell_index in range(len(coords), 0, -1):
		var cell:Dictionary = coords[cell_index - 1]
		cell.tile = get_cell_autotile_coord(cell.to.x, cell.to.y)
		
		var cell_map:TileMap = duplicate_map()
		
		# Create a cell on the overlay map
		cell_map.set_cell(cell.to.x, cell.to.y, tileset_index, false, false, false, cell.tile)
		
		# Remove the cell from the real map
		set_cell(cell.to.x, cell.to.y, -1)
		
		var delta:Vector2 = cell.from - cell.to
		if delta.x < -1:
			delta.x = -1
		elif delta.x > 1:
			delta.x = 1
		if delta.y < -1:
			delta.y = -1
		elif delta.y > 1:
			delta.y = 1
		
		# Animate the overlay to slide from the old tile position to the new tile position
		var target_position:Vector2 = cell_map.cell_size * delta
		
		cell_map.modulate.a = 1
		Tweens.tween(cell_map, "modulate:a", 1, 0.25, 0.15)
		Tweens.tween(cell_map, "position", cell_map.position, target_position, 0.15)
	
	yield(Timers.wait(0.25), "completed")
	for map in get_children():
		if map is TileMap:
			map.queue_free()
		
	update_bitmask_region()


#
# HELPER METHODS
#

func get_midpoint_cell() -> Vector2:
	var used:Rect2 = get_used_rect()
	var midpoint:Vector2 = Vector2(
		used.position.x + (used.size.x / 2),
		used.position.y + (used.size.y / 2)
	)
	return midpoint

func get_midpoint_position() -> Vector2:
	var midpoint:Vector2 = get_midpoint_cell()
	var midpoint_position:Vector2 = Vector2(
		(midpoint.x * cell_size.x) - (cell_size.x / 2),
		(midpoint.y * cell_size.y) - (cell_size.y / 2)
	)
	return midpoint_position

func get_furthest_cell_value(direction:int=Globals.Direction.LEFT) -> int:
	var used:Rect2 = get_used_rect()
	
	match direction:
		Globals.Direction.LEFT:
			return int(used.position.x)
		Globals.Direction.RIGHT:
			return int(used.end.x - 1)
		Globals.Direction.UP:
			return int(used.position.y)
		Globals.Direction.DOWN:
			return int(used.end.y - 1)
		_:
			return 0

func get_furthest_position(direction:int=Globals.Direction.LEFT) -> float:
	var furthest_cell:int = get_furthest_cell_value(direction)
	
	match direction:
		Globals.Direction.LEFT, Globals.Direction.RIGHT:
			return furthest_cell * cell_size.x
		Globals.Direction.UP, Globals.Direction.DOWN:
			return furthest_cell * cell_size.y
		_:
			return 0.0
			
func get_cells_between_coords(from_coord:Vector2, to_coord:Vector2) -> Array:
	var cells:Array = []
	
	var x_delta:int = int(to_coord.x - from_coord.x)
	var y_delta:int = int(to_coord.y - from_coord.y)
	
	var x_range:Array = (
			range(from_coord.x + 1, to_coord.x + 1)
			if x_delta > 0
			else range(from_coord.x - 1, to_coord.x - 1, -1)
			if x_delta < 0
			else [from_coord.x]
	)
	
	var y_range:Array = (
			range(from_coord.y + 1, to_coord.y + 1)
			if y_delta > 0
			else range(from_coord.y - 1, to_coord.y - 1, -1)
			if y_delta < 0
			else [from_coord.y]
	)
	
	for y in y_range:
		for x in x_range:
			cells.append({
				from = from_coord,
				to = Vector2(x, y),
			})
	
	return cells

func get_furthest_cells(direction:int=Globals.Direction.LEFT) -> Array:
	var cells:Array = []
	var used_cells:Array = get_used_cells()
	var furthest_cell_value:int = get_furthest_cell_value(direction)
	
	for cell in used_cells:
		match direction:
			Globals.Direction.LEFT, Globals.Direction.RIGHT:
				if cell.x == furthest_cell_value:
					cells.append(cell)
			Globals.Direction.UP, Globals.Direction.DOWN:
				if cell.y == furthest_cell_value:
					cells.append(cell)
	
	return cells

func add_to_direction(direction:int=Globals.Direction.LEFT, remove:bool=false) -> void:
	
	var furthest_cells:Array = get_furthest_cells(direction)
	
	var delta:Vector2 = Vector2(0, 0)
	match direction:
		Globals.Direction.LEFT:
			delta.x = -1
		Globals.Direction.RIGHT:
			delta.x = 1
		Globals.Direction.UP:
			delta.y = -1
		Globals.Direction.DOWN:
			delta.y = 1
	
	var cells_to_set:Array = []
	for cell in furthest_cells:
		cells_to_set.append({
			from = cell if not remove else cell - delta,
			to = cell + delta if not remove else cell
		})
	
	if not remove:
		yield(slide_set_cells(cells_to_set), "completed")
	else:
		yield(slide_erase_cells(cells_to_set), "completed")

#
# CUSTOM SORT METHODS
#

func sort_cells_by_x(cell_a:Vector2, cell_b:Vector2) -> bool:
	return cell_a.x > cell_b.x
	
func sort_cells_by_y(cell_a:Vector2, cell_b:Vector2) -> bool:
	return cell_a.y > cell_b.y














