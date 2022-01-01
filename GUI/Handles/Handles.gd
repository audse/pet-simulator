extends Node2D

signal handle_drag_released(from_pos, to_pos, handle)
onready var Drag = preload("res://Nodes/Drag.tscn")

var handle_icon_animation:SpriteFrames = preload("res://Assets/Sprites/GUI/icon_bubble.tres")
var _connect

func handle_drag_started(handle:Node) -> void:
	Globals.disable_camera_drag()
	handle.modulate.a = 1
	handle.modulate.g = 0.5
	handle.modulate.b = 0.5
	disable_others(handle)

func handle_dragging(drag_delta:Vector2, handle:Node) -> void:
	handle.global_position += drag_delta

func handle_drag_released(from_pos:Vector2, to_pos:Vector2, handle:Node) -> void:
	Globals.enable_camera_drag()
	enable_all()
	emit_signal("handle_drag_released", from_pos, to_pos, handle)

func draw_from_tilemap(map:TileMap, exclude_tiles:Array=[]) -> void:
	for cell in map.get_used_cells():
		var cell_position = map.map_to_world(cell)
		var cell_tile = map.get_cell_autotile_coord(cell.x, cell.y)
		
		if not cell_tile in exclude_tiles:
			# Create handle
			var new_handle:AnimatedSprite = create_handle(cell_position)
			add_child(new_handle)
			
			# Attach drag information
			make_draggable(new_handle)

func create_handle(handle_position:Vector2) -> Node:
	# Create animated sprite
	var new_handle:AnimatedSprite = AnimatedSprite.new()
	new_handle.frames = handle_icon_animation
	new_handle.play("default")
	
	new_handle.global_position = handle_position + Vector2(12, 12)
	new_handle.modulate.a = 0.75
	
	return new_handle

func make_draggable(handle:Node) -> void:
	var new_drag:Drag = Drag.instance()
	handle.add_child(new_drag)
	
	_connect = new_drag.connect("drag_started", self, "handle_drag_started", [handle])
	_connect = new_drag.connect("dragging", self, "handle_dragging", [handle])
	_connect = new_drag.connect("drag_released", self, "handle_drag_released", [handle])

func snap_to_tilemap(map:TileMap, current_handle:Node) -> void:
	var grid_coord:Vector2 = map.world_to_map(current_handle.position)
	current_handle.position = map.map_to_world(grid_coord) + Vector2(12, 12)
	
func delete_all() -> void:
	for handle in get_children():
		delete(handle)

func delete(current_handle:Node) -> void:
	yield(fade_out(current_handle), "completed")
	current_handle.queue_free()

func enable_all() -> void:
	for handle in get_children():
		fade_in(handle)
		handle.get_child(0).disabled = false

func disable_all() -> void:
	for handle in get_children():
		fade(handle)
		handle.get_child(0).disabled = true

func enable_others(current_handle:Node) -> void:
	for handle in get_children():
		if handle != current_handle:
			fade_in(handle)
			handle.get_child(0).disabled = false

func disable_others(current_handle:Node) -> void:
	for handle in get_children():
		if handle != current_handle:
			fade(handle)
			handle.get_child(0).disabled = true
	
func fade(current_handle:Node) -> void:
	yield(Tweens.tween(
			current_handle,
			"modulate:a",
			current_handle.modulate.a,
			0.5,
			0.25
		), "completed")
	
func fade_in(current_handle:Node) -> void:
	yield(Tweens.tween(
			current_handle,
			"modulate:a",
			current_handle.modulate.a,
			0.75,
			0.25
		), "completed")
	
func fade_out(current_handle:Node) -> void:
	yield(Tweens.tween(
			current_handle,
			"modulate:a",
			current_handle.modulate.a,
			0,
			0.25
		), "completed")
