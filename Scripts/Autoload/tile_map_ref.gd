class_name TileMapRef
extends Object


enum Action {
	SET_CELLS,
	ERASE_CELLS,
	ADD_TO_DIRECTION
}


static func get_delta_from_direction(direction:int, amount:int=1) -> Vector2:
	""" get_delta_from_direction

	`delta` is `amount` converted into coordinates
	representing the change of a particular direction
	
	:param direction: int, one of Globals.Direction
	:param amount: int

	# Example 1:
		(direction=left, amount=1)
		returns (-1, 0)
		
		the farthest left column would have x coord of 0
		so delta -1 means a column to the left of the leftmost column
		
	# Example 2:
		(direction=left, amount=-1)
		returns (1, 0)
		the farthest left column has x of 0
		so x of 1 would be inside the map and need to be deleted
		
	"""
	var delta:Vector2 = Vector2(0, 0)
	match direction:
		Globals.Direction.LEFT:
			delta.x = -amount
		Globals.Direction.RIGHT:
			delta.x = amount
		Globals.Direction.UP:
			delta.y = -amount
		Globals.Direction.DOWN:
			delta.y = amount
	return delta



static func get_midpoint_cell(map:TileMap) -> Vector2:
	var used:Rect2 = map.get_used_rect()
	var midpoint:Vector2 = Vector2(
		used.position.x + (used.size.x / 2),
		used.position.y + (used.size.y / 2)
	)
	return midpoint


static func get_midpoint_position(map:TileMap) -> Vector2:
	var midpoint:Vector2 = get_midpoint_cell(map)
	return map.map_to_world(midpoint)


static func get_furthest_cell_value(map:TileMap, direction:int=Globals.Direction.LEFT) -> int:
	var used:Rect2 = map.get_used_rect()
	
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


static func get_furthest_position(map:TileMap, direction:int=Globals.Direction.LEFT) -> Vector2:
	var furthest_cell:int = get_furthest_cell_value(map, direction)
	
	match direction:
		Globals.Direction.LEFT, Globals.Direction.RIGHT:
			return map.map_to_world(Vector2(furthest_cell, 0))
		Globals.Direction.UP, Globals.Direction.DOWN:
			return map.map_to_world(Vector2(0, furthest_cell))
		_:
			return Vector2.ZERO


static func get_bounding_box(map:TileMap) -> Dictionary:
	return {
		Globals.Direction.LEFT: get_furthest_position(map, Globals.Direction.LEFT),
		Globals.Direction.RIGHT: get_furthest_position(map, Globals.Direction.RIGHT),
		Globals.Direction.UP: get_furthest_position(map, Globals.Direction.UP),
		Globals.Direction.DOWN: get_furthest_position(map, Globals.Direction.DOWN),
	}


static func sort_cells_by_x(cell_a:Vector2, cell_b:Vector2) -> bool:
	return cell_a.x > cell_b.x


static func sort_cells_by_y(cell_a:Vector2, cell_b:Vector2) -> bool:
	return cell_a.y > cell_b.y


static func parse_animated_cell_array(cell_set:Array, action:int) -> Array:
	var cell_array:Array = []
	match action:
		Action.SET_CELLS:
			for cell in cell_set:
				cell_array.append(cell.to)
		Action.ERASE_CELLS:
			for cell in cell_set:
				cell_array.append(cell.from)
	return cell_array
