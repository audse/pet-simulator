class_name AnimatedAutotile
extends TileMap


signal slide_finished

export var tile_set_index:int = 0


func _init(
	tile_set_value:TileSet=tile_set, 
	cell_size_value:Vector2=cell_size, 
	tile_set_index_value:int=0,
	mode_value:int=mode
) -> void:
	tile_set = tile_set_value
	cell_size = cell_size_value
	tile_set_index = tile_set_index_value
	mode = mode_value


func slide_set_cells(coords:Array, time:float=0.35) -> void:
	for cell in coords:
		# Set the cell on the real map to find the correct autotile coords
		set_cell(cell.to.x, cell.to.y, tile_set_index)
	
	if tile_set:
		update_bitmask_region()
	
	for cell in coords:
		cell.tile = get_cell_autotile_coord(cell.to.x, cell.to.y)
		# Remove the cell so it doesn't show before animating
		set_cell(cell.to.x, cell.to.y, -1)
		
		# Create a cell on the overlay map
		var cell_map:TileMap = duplicate_map()
		cell_map.set_cell(cell.to.x, cell.to.y, tile_set_index, false, false, false, cell.tile)
		
		var delta:Vector2 = cell.to - cell.from
#		if cell_map.mode == MODE_ISOMETRIC:
#			delta.y += 0.5
#			delta.x *= 0.5
		
		# Animate the overlay to slide from the old tile position to the new tile position
#		cell_map.position = - cell_map.cell_size * delta
		cell_map.position = - cell_map.map_to_world(delta)
		
	for map in get_children():
		if map is TileMap:
			Tweens.tween(map, "position", map.position, Vector2(0, 0), time)
	
	yield(Timers.wait(time), "completed")
	yield(get_tree(), "idle_frame")
	
	for map in get_children():
		if map is TileMap:
			map.queue_free()
			
	for cell in coords:
		# Add the cell back to the real map
		set_cell(cell.to.x, cell.to.y, tile_set_index)
	
	if tile_set:
		update_bitmask_region()
	emit_signal("slide_finished")


func slide_erase_cells(coords:Array, time:float=0.35) -> void:
	for cell_index in range(len(coords)):
		
		var cell:Dictionary = coords[cell_index - 1]
		cell.tile = get_cell_autotile_coord(cell.from.x, cell.from.y)
		
		var cell_map:TileMap = duplicate_map()
		
		# Create a cell on the overlay map
		cell_map.set_cell(cell.from.x, cell.from.y, tile_set_index, false, false, false, cell.tile)
		
		# Remove the cell from the real map
		set_cell(cell.from.x, cell.from.y, -1)
		
		var delta:Vector2 = cell.to - cell.from
		
		# Animate the overlay to slide from the old tile position to the new tile position
#		var target_position:Vector2 = cell_map.cell_size * delta
		var target_position:Vector2 = cell_map.map_to_world(delta)
		
		Tweens.tween(cell_map, "position", cell_map.position, target_position, time)
	
	yield(Timers.wait(time), "completed")
	for map in get_children():
		if map is TileMap:
			map.queue_free()
		
	if tile_set:
		update_bitmask_region()
	emit_signal("slide_finished")


func slide_add_to_direction(direction:int=Globals.Direction.LEFT, num_additions:int=1, time:float=0.25):
	var is_erasing:bool = num_additions < 0
	var cells_to_set:Array = add_to_direction(direction, num_additions)
	if not is_erasing:
		yield(slide_set_cells(cells_to_set, time), "completed")
	else:
		yield(slide_erase_cells(cells_to_set, time), "completed")
	emit_signal("slide_finished")


func duplicate_map() -> TileMap:
	var new_map:TileMap = TileMap.new()
	new_map.mode = mode
	new_map.tile_set = tile_set
	new_map.cell_size = cell_size
	add_child(new_map)
	return new_map

#
# HELPER METHODS
#


func get_midpoint_cell() -> Vector2:
	return TileMapRef.get_midpoint_cell(self)
#	var used:Rect2 = get_used_rect()
#	var midpoint:Vector2 = Vector2(
#		used.position.x + (used.size.x / 2),
#		used.position.y + (used.size.y / 2)
#	)
#	return midpoint


func get_midpoint_position() -> Vector2:
	return TileMapRef.get_midpoint_position(self)
#	var midpoint:Vector2 = get_midpoint_cell()
#	return map_to_world(midpoint)


func get_furthest_cell_value(direction:int=Globals.Direction.LEFT) -> int:
	return TileMapRef.get_furthest_cell_value(self, direction)
#	var used:Rect2 = get_used_rect()
#
#	match direction:
#		Globals.Direction.LEFT:
#			return int(used.position.x)
#		Globals.Direction.RIGHT:
#			return int(used.end.x - 1)
#		Globals.Direction.UP:
#			return int(used.position.y)
#		Globals.Direction.DOWN:
#			return int(used.end.y - 1)
#		_:
#			return 0


func get_furthest_position(direction:int=Globals.Direction.LEFT) -> Vector2:
	return TileMapRef.get_furthest_position(self, direction)
#	var furthest_cell:int = get_furthest_cell_value(direction)
#	var _midpoint:Vector2 = get_midpoint_cell()
#
#	match direction:
#		Globals.Direction.LEFT, Globals.Direction.RIGHT:
#			return map_to_world(Vector2(furthest_cell, 0))
#		Globals.Direction.UP, Globals.Direction.DOWN:
#			return map_to_world(Vector2(0, furthest_cell))
#		_:
#			return Vector2.ZERO


func get_bounding_box() -> Dictionary:
	return TileMapRef.get_bounding_box(self)
#	return {
#		left = get_furthest_position(Globals.Direction.LEFT),
#		right = get_furthest_position(Globals.Direction.RIGHT),
#		up = get_furthest_position(Globals.Direction.UP),
#		down = get_furthest_position(Globals.Direction.DOWN),
#	}



func get_cells_between_coords(from_coord:Vector2, to_coord:Vector2) -> Array:
	var cells:Array = []
	
	var delta:Vector2 = to_coord - from_coord
	var factor:Vector2 = Vector2Ref.normalize_to_one(delta)
	
	var x_range:Array = range(abs(delta.x)) if delta.x != 0 else [0]
	var y_range:Array = range(abs(delta.y)) if delta.y != 0 else [0]
	
	for y in y_range:
		for x in x_range:
			cells.append({
				from = from_coord + (Vector2(x, y) * factor),
				to = from_coord + (Vector2(x + 1, y + 1) * factor)
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


""" add_to_direction

Create (or erases) a new row or column in the specified direction

# Arguments
`direction` = int
	- one of Globals.Direction enum
`num_additions` = int
	- number of rows or columns to add to the map
	- a negative number indicates removing rows or columns

"""
func add_to_direction(direction:int=Globals.Direction.LEFT, num_additions:int=1) -> Array:
	
	var furthest_cells:Array = get_furthest_cells(direction)
	var cells_to_set:Array = []
	var is_erasing:bool = num_additions < 0
	var total_delta:Vector2 = TileMapRef.get_delta_from_direction(direction, num_additions)
	
	for index in range(abs(num_additions)):
		
		for cell in furthest_cells:
			
			if not is_erasing:
				cells_to_set.append({
					from = cell,
					# warning-ignore:narrowing_conversion
					to = cell + TileMapRef.get_delta_from_direction(direction, abs(index) + 1)
				})
			else:
				cells_to_set.append({
					# warning-ignore:narrowing_conversion
					from = cell - TileMapRef.get_delta_from_direction(direction, abs(index)),
					to = cell + total_delta
				})
				
	return cells_to_set




