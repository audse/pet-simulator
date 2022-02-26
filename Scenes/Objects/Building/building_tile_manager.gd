class_name BuildingTileManager
extends Resource

signal slide_finished
signal base_map_changed

enum Action {
	SET_CELLS,
	ERASE_CELLS,
	ADD_TO_DIRECTION
}

var base_map:AnimatedAutotile setget set_base_map, get_base_map 

var autotile_coords:Dictionary = {
	undraggable = [
		Vector2(2, 1),
		Vector2(9, 2),
		Vector2(5, 1),
		Vector2(5, 2),
		Vector2(6, 1),
		Vector2(6, 2),
		Vector2(8, 2),
		Vector2(10, 3),
		Vector2(11, 1),
		Vector2(9, 0),
		Vector2(9, 1),
		Vector2(10, 2)
	],
	exterior = [
		Vector2(0, 2),
		Vector2(0, 3),
		Vector2(1, 2),
		Vector2(2, 2),
		Vector2(3, 2),
		Vector2(0, 3),
		Vector2(1, 3),
		Vector2(2, 3),
		Vector2(3, 3),
		Vector2(5, 3),
		Vector2(6, 3),
		Vector2(8, 3),
		Vector2(9, 3),
		Vector2(11, 3),
	]
}


func get_cells_to_set(from_coord:Vector2, to_coord:Vector2) -> Dictionary:
	var cells_to_set:Array = base_map.get_cells_between_coords(
		from_coord,
		to_coord
	)
	
	# From the cells to set, find which ones are already used
	var cells_already_used:Array = []
	for cell in cells_to_set:
		if base_map.get_cellv(cell.to) != -1:
			cells_already_used.append(cell)
	
	# If all the cells to set are already used, 
	# the user probably wants to delete, not add
	if len(cells_to_set) == len(cells_already_used):
		
		# Adjust the `to` coord so that all tiles land
		# on the currently handled cell
		for cell in cells_to_set:
			cell.to = to_coord
		
		# We don't want to delete if no cells have been passed
		if to_coord != from_coord:
			return {
				cells = cells_to_set,
				action = Action.ERASE_CELLS
			}
	
	else:
		# Adjust the `from` coord so that all tiles spawn
		# at the original point, rather than near the final point
		for cell in cells_to_set:
			cell.from = from_coord
		
		return {
			cells = cells_to_set,
			action = Action.SET_CELLS
		}

	return {}


func set_base_map(new_base_map:AnimatedAutotile) -> void:
	base_map = new_base_map
	emit_signal("base_map_changed")


func get_base_map() -> AnimatedAutotile:
	return base_map
