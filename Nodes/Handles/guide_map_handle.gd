class_name GuideMapHandle
extends Handle

signal set_guide_cells(cells, node)

enum Action {
	SET,
	ERASE
}

var base_map:AnimatedAutotile

var from_coord:Vector2
var to_coord:Vector2
var latest_position:Vector2
var is_updating:bool = false

func _init(
		base_map_value:TileMap,
		args:Dictionary
).(args) -> void:
	base_map = base_map_value


func _input(event:InputEvent) -> void:
	event = make_input_local(event)
	if nodes.drag and nodes.drag.is_dragging:
		var current_position:Vector2 = to_global(event.position)
		if base_map and latest_position.distance_to(current_position) > 2:
			is_updating = true
			latest_position = current_position
			to_coord = base_map.world_to_map(current_position)
			
			emit_signal("set_guide_cells", get_cells_passed(), self)
		else:
			is_updating = false
	else:
		from_coord = Vector2.ZERO
		to_coord = Vector2.ZERO
		latest_position = Vector2.ZERO
		is_updating = false


func get_coord() -> Vector2:
	return base_map.world_to_map(latest_position)


func get_cells_passed() -> Dictionary:	
	var cells_to_set:Array = base_map.get_cells_between_coords(from_coord, to_coord)
	
	var cells_already_used:Array = []
	for cell in cells_to_set:
		if base_map.get_cellv(cell.to) != -1:
			cells_already_used.append(cell)
	
	# If all the cells to set are already used, 
	# the user probably wants to delete, not add
	if len(cells_to_set) == len(cells_already_used):
		
		var new_addition:Dictionary = {
			cell_set = [],
			action = Action.ERASE
		}
		for cell in cells_to_set:
			new_addition.cell_set.append(cell.from)
		return new_addition
		
	else:
		var new_addition:Dictionary = {
			cell_set = [],
			action = Action.SET
		}
		for cell in cells_to_set:
			new_addition.cell_set.append(cell.to)
		return new_addition


func handle_drag_started(from_pos:Vector2) -> void:
	if base_map:
		from_coord = base_map.world_to_map(from_pos)
		to_coord = base_map.world_to_map(from_pos)
		latest_position = from_pos
	.handle_drag_started(from_pos)
