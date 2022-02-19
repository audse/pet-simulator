class_name GuideMapHandleGroup
extends HandleGroup

export(TileSet) var tile_set:TileSet = preload("res://Assets/Tiles/Grids/tres/isometric_grid_48x24_tile_set.tres")
export(Vector2) var cell_size:Vector2 = Vector2(48, 24)
export(NodePath) var base_map_path:NodePath
export(bool) var is_autotile:bool
export(int) var mode:int = TileMap.MODE_ISOMETRIC

export(Dictionary) var guide_map_modulate_colors:Dictionary = {
	positive = Color("#2d884d"),
	negative = Color("#d23843")
}

var latest_addition:Dictionary = {
	direction = Globals.Direction.NONE,
	num_additions = 0,
	cell_set = []
}

var guide:Dictionary = {
	container = Node2D.new(),
	tile_map = AnimatedAutotile.new(
		tile_set,
		cell_size,
		mode
	)
}

var base_map:TileMap setget set_base_map, get_base_map


func _init(base_map_value:TileMap=null, is_autotile_value:bool=false) -> void:
	base_map = base_map_value
	
	guide.tile_map.cell_size = base_map.cell_size
	guide.tile_map.mode = base_map.mode
	
	is_autotile = is_autotile_value


func _enter_tree() -> void:
	add_child(guide.container)
	guide.container.add_child(guide.tile_map)


func _ready() -> void:
	if not base_map and base_map_path:
		base_map = get_parent().get_node(base_map_path)


func draw_from_base_map(exclude_tiles:Array=[], extra_args:Dictionary={}) -> void:
	if is_instance_valid(base_map):
		for cell in base_map.get_used_cells():
			extra_args.start_position = base_map.map_to_world(cell)
			
			if is_autotile:
				var cell_tile = base_map.get_cell_autotile_coord(cell.x, cell.y)
				
				if not cell_tile in exclude_tiles:
					add_handle(extra_args)
			else:
				add_handle(extra_args)


func add_handle(extra_args:Dictionary) -> void:
	for arg_key in extra_args.keys():
		args[arg_key] = extra_args[arg_key]
	
	var new_handle:GuideMapHandle = GuideMapHandle.new(base_map, args)
	add_child(new_handle)
	
	_connect = new_handle.connect("handle_drag_started", self, "handle_drag_started")
	_connect = new_handle.connect("handle_drag_released", self, "handle_drag_released")
	_connect = new_handle.connect("set_guide_cells", self, "set_guide_cells")


func set_guide_cells(cells_to_set:Dictionary, handle:GuideMapHandle) -> void:
	if (
		is_instance_valid(guide.tile_map)
		and is_instance_valid(guide.container)
		and is_instance_valid(handle)
	):

		var only_cell_is_under_handle:bool = handle.from_coord == handle.to_coord

		if latest_addition.cell_set != cells_to_set.cell_set:
			guide.tile_map.clear()

			for cell in base_map.get_used_cells():
				guide.tile_map.set_cellv(cell, 0)
			guide.tile_map.update_bitmask_region()

			if cells_to_set.action == handle.Action.SET:
				guide.container.modulate = guide_map_modulate_colors.positive
			else:
				guide.container.modulate = guide_map_modulate_colors.negative

			if not only_cell_is_under_handle:
				for cell in cells_to_set.cell_set:
					guide.tile_map.set_cellv(cell, 0)

				guide.tile_map.update_bitmask_region()

				for cell in base_map.get_used_cells():
					if not cell in cells_to_set.cell_set:
						guide.tile_map.set_cellv(cell, -1)

				latest_addition.cell_set = cells_to_set.cell_set

		if only_cell_is_under_handle:
			guide.tile_map.clear()
			latest_addition.cell_set = []


func handle_drag_released(from_pos:Vector2, to_pos:Vector2, handle:Handle) -> void:
	if is_instance_valid(guide.tile_map):
		guide.tile_map.clear()
		from_pos = guide.tile_map.world_to_map(from_pos)
		to_pos = guide.tile_map.world_to_map(to_pos)
	
	.handle_drag_released(from_pos, to_pos, handle)


func set_base_map(new_base_map:TileMap) -> void:
	base_map = new_base_map
	for handle in get_children():
		if handle is GuideMapHandle:
			
			handle.base_map = new_base_map
			
			guide.tile_map.cell_size = base_map.cell_size
			guide.tile_map.mode = base_map.mode


func get_base_map() -> TileMap:
	return base_map
