extends Node2D

class_name ConstructWall
onready var Drag = preload("res://Nodes/Drag.tscn")

var handle_icon_animation:SpriteFrames = preload("res://Assets/Sprites/GUI/icon_bubble.tres")
var base_map:TileMap
var _connect

func _ready():
	$TileMap.modulate.a = 0

func place(new_base_map:TileMap) -> void:
	base_map = new_base_map
	# Show grid highlight
	$GridHighlight.start($TileMap)
	Tweens.pop_in($GridHighlight/AddButton)

func start(start_x:int, start_y:int) -> void:
	$TileMap.set_cell(start_x, start_y, 0)
	$TileMap.update_bitmask_region()
	
	$Handles.draw_from_tilemap($TileMap)
	Tweens.tween($TileMap, "modulate:a", 0, 1, 0.5)
	
	if base_map:
		adjust_tile_z_index()
	
func stop() -> void:
	$Handles.delete_all()
	# Hide grid highlight
	$GridHighlight.stop()
	Tweens.pop_out($GridHighlight/AddButton)
	
func resume() -> void:
	$Handles.draw_from_tilemap($TileMap)

func _on_handle_drag_released(from_pos:Vector2, to_pos:Vector2, handle:Node) -> void:
	$Handles.snap_to_tilemap($TileMap, handle)
	$Handles.delete_all()
	
	# Reset masked tiles to original
	if base_map:
		for cell in $TileMap.get_used_cells():
			if $TileMap.get_cell(cell.x, cell.y) == 1:
				$TileMap.set_cell(cell.x, cell.y, 0)
	
	var from_coord:Vector2 = $TileMap.world_to_map(to_global(from_pos))
	var to_coord:Vector2 = $TileMap.world_to_map(to_global(to_pos))
	
	var cells_to_set:Array = $TileMap.get_cells_between_coords(from_coord, to_coord)
	var cells_already_used:Array = []
	for cell in cells_to_set:
		if $TileMap.get_cellv(cell.to) != -1:
			cells_already_used.append(cell)
	
	# If all the cells to set are already used, 
	# the user probably wants to delete, not add
	if len(cells_to_set) == len(cells_already_used) and len(cells_to_set) > 0:
		# Add the originally handled cell to the erase list
		cells_to_set.push_front({from = cells_to_set[0].to, to = from_coord})
		# Remove the currently handled cell from the erase list
		for cell in cells_to_set:
			if cell.to == to_coord:
				cells_to_set.remove(cells_to_set.find(cell))
				
		yield($TileMap.slide_erase_cells(cells_to_set), "completed")
	else:
		yield($TileMap.slide_set_cells(cells_to_set), "completed")
	
	$Handles.draw_from_tilemap($TileMap)
	
	if base_map:
		adjust_tile_z_index()

func adjust_tile_z_index() -> void:
	for cell in $TileMap.get_used_cells():
		# Check if inner wall is hovering above an outer wall
		var tile:Vector2 = base_map.get_cell_autotile_coord(cell.x, cell.y)
		var outer_wall_tiles:Array = [
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2), Vector2(3, 2),  Vector2(0, 3), Vector2(1, 3), Vector2(2, 3), Vector2(3, 3), Vector2(5, 3), Vector2(6, 3), Vector2(8, 3), Vector2(9, 3), Vector2(11, 3)
		]
		
		# Replace current inner wall tile with a masked version
		if tile in outer_wall_tiles:
			var wall_tile:Vector2 = $TileMap.get_cell_autotile_coord(cell.x, cell.y)
			$TileMap.set_cell(cell.x, cell.y, 1, false, false, false, wall_tile)

func _on_AddButton_pressed():
	var coords:Vector2 = $TileMap.world_to_map($GridHighlight.position)
	start(coords.x, coords.y)
	
	yield(Tweens.pop_out($GridHighlight/AddButton), "completed")
	$GridHighlight.stop()
