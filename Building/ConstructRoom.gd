extends Node2D

class_name ConstructRoom

onready var Drag:PackedScene = preload("res://Nodes/Drag.tscn")
onready var ConstructWall:PackedScene = preload("res://Building/ConstructWall.tscn")
var handle_icon_animation:SpriteFrames = preload("res://Assets/Sprites/GUI/icon_bubble.tres")

var undraggable_tiles:Array = [Vector2(2, 1), Vector2(9, 2), Vector2(5, 1), Vector2(5, 2), Vector2(6, 1), Vector2(6, 2), Vector2(8, 2), Vector2(10, 3), Vector2(11, 1), Vector2(9, 0), Vector2(9, 1), Vector2(10, 2)]

var _connect

func _ready():
	$TileMap.modulate.a = 0
	
	_connect = Events.connect("construct_toggle_mode", self, "_on_construct_toggle_mode")
	_connect = Events.connect("construct_add_wall_pressed", self, "_on_construct_add_wall_pressed")

func start(start_x:int, start_y:int) -> void:
	for y in [start_y - 1, start_y, start_y + 1]:
		for x in [start_x - 1, start_x, start_x + 1]:
			$TileMap.set_cell(x, y, 0)
	$TileMap.update_bitmask_region()
	Tweens.tween($TileMap, "modulate:a", 0, 1, 0.5)
	$Handles.draw_from_tilemap($TileMap, undraggable_tiles)
	draw_arrows()

func stop() -> void:
	for handle in $Handles.get_children():
		handle.queue_free()
	$Arrows.visible = false

func stop_all() -> void:
	stop()
	for wall in $Walls.get_children():
		wall.stop()

func resume() -> void:
	$TileMap.update_bitmask_region()
	Tweens.tween($TileMap, "modulate:a", 0, 1, 0.5)
	$Handles.draw_from_tilemap($TileMap, undraggable_tiles)
	draw_arrows()

func show_edit_button() -> void:
	$EditButton.modulate.a = 0
	$EditButton.rect_position = $TileMap.get_midpoint_position() - Vector2(5, 15)
	$EditButton.visible = true
	Tweens.pop_in($EditButton)

func hide_edit_button() -> void:
	yield(Tweens.pop_out($EditButton), "completed")
	$EditButton.visible = false

func draw_roof() -> void:
	$Roof.modulate.a = 0
	for cell in $TileMap.get_used_cells():
		$Roof.set_cellv(cell, 0)
	$Roof.update_bitmask_region()
	Tweens.tween($Roof, "modulate:a", $Roof.modulate.a, 1, 0.5)

func hide_roof() -> void:
	Tweens.tween($Roof, "modulate:a", $Roof.modulate.a, 0, 0.5)

func draw_arrows() -> void:
	adjust_arrow_positions(false)
	$Arrows.visible = true
	$Arrows.modulate.a = 0
	Tweens.tween($Arrows, "modulate:a", 0, 1, 0.5)

func adjust_arrow_positions(animate:bool=true) -> void:
	var new_arrow_positions = get_arrow_positions()
	var arrows:Dictionary = {
		right = $Arrows/Right,
		left = $Arrows/Left,
		up = $Arrows/Up,
		down = $Arrows/Down
	}
	for key in arrows:
		if animate:
			Tweens.tween(
				arrows[key],
				"rect_position",
				arrows[key].rect_position,
				new_arrow_positions[key],
				0.15
			)
		else:
			arrows[key].rect_position = new_arrow_positions[key]

func get_arrow_positions() -> Dictionary:
	var offset:Vector2 = $TileMap.cell_size * 2
	var midpoint:Vector2 = $TileMap.get_midpoint_position()
	
	var furthest:Dictionary = {
		down = $TileMap.get_furthest_position(Globals.Direction.DOWN),
		up = $TileMap.get_furthest_position(Globals.Direction.UP),
		right = $TileMap.get_furthest_position(Globals.Direction.RIGHT),
		left = $TileMap.get_furthest_position(Globals.Direction.LEFT),
	}
	
	return {
		down = Vector2(midpoint.x, furthest.down + offset.y),
		up = Vector2(midpoint.x, furthest.up - offset.y),
		right = Vector2(furthest.right + offset.x, midpoint.y),
		left = Vector2(furthest.left - offset.x, midpoint.y)
	}

func add_to_direction(direction:int, remove:bool=false) -> void:
	$Handles.delete_all()
	
	yield($TileMap.add_to_direction(direction, remove), "completed")
	
	$Handles.draw_from_tilemap($TileMap, undraggable_tiles)
	adjust_arrow_positions()

func _on_handle_drag_released(from_pos:Vector2, to_pos:Vector2, handle:Node) -> void:
	$Handles.delete_all()
	
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
	
	$Handles.draw_from_tilemap($TileMap, undraggable_tiles)
	adjust_arrow_positions()

func add_wall() -> void:
	var new_construct_wall:ConstructWall = ConstructWall.instance()
	$Walls.add_child(new_construct_wall)
	new_construct_wall.place($TileMap)

func stop_all_walls() -> void:
	for wall in $Walls.get_children():
		wall.stop()
		wall.adjust_tile_z_index()

func resume_last_wall() -> void:
	if $Walls.get_child_count() > 1:
		$Walls.get_child($Walls.get_child_count() - 1).resume()

func _on_ArrowRight_pressed():
	add_to_direction(Globals.Direction.RIGHT)

func _on_ArrowLeft_pressed():
	add_to_direction(Globals.Direction.LEFT)

func _on_ArrowUp_pressed():
	add_to_direction(Globals.Direction.UP)

func _on_ArrowDown_pressed():
	add_to_direction(Globals.Direction.DOWN)

func _on_ArrowRightBack_pressed():
	add_to_direction(Globals.Direction.RIGHT, true)

func _on_ArrowLeftBack_pressed():
	add_to_direction(Globals.Direction.LEFT, true)

func _on_ArrowUpBack_pressed():
	add_to_direction(Globals.Direction.UP, true)
	
func _on_ArrowDownBack_pressed():
	add_to_direction(Globals.Direction.DOWN, true)

func _on_construct_toggle_mode(mode:int) -> void:
	if mode == States.ConstructMode.WALL: # Wall Mode
		stop()
		resume_last_wall()
		
	elif mode == States.ConstructMode.SHAPE: # Shape Mode
		stop_all_walls()
		resume()

func _on_construct_add_wall_pressed():
	stop_all_walls()
	add_wall()

func _on_EditButton_pressed():
	resume()
	hide_edit_button()
	hide_roof()
	Events.emit_signal("construct_editing")
