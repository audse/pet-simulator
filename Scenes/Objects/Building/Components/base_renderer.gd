class_name BuildingBaseRenderer
extends BuildingMapComponent

var resource_manager:BuildResourceManager = BuildResourceManager.new()


func _init(
	data_value:BuildingData,
	input_value:BuildingInput,
	tile_manager:BuildingTileManager
).(data_value, input_value, tile_manager) -> void:
	pass


func _enter_tree() -> void:
	maps.walls = AnimatedAutotile.new(
		resource_manager.tile_sets.walls,
		resource_manager.cell_size,
		0,
		TileMap.MODE_ISOMETRIC
	)
	maps.floor = AnimatedAutotile.new(
		resource_manager.tile_sets.floor,
		resource_manager.cell_size,
		0,
		TileMap.MODE_ISOMETRIC
	)
#	maps.walls = AnimatedAutotile.new(
#		resource_manager.tile_sets.walls,
#		resource_manager.cell_size,
#		0,
#		TileMap.MODE_ISOMETRIC
#	)
#	maps.roof = AnimatedAutotile.new(
#		resource_manager.tile_sets.roof,
#		resource_manager.cell_size,
#		0,
#		TileMap.MODE_ISOMETRIC
#	)
#	maps.roof.position.y = -22
#	maps.roof.visible = false
	
	for map in maps.values():
		add_child(map)
		
	tile_manager.base_map = maps.floor


func _ready() -> void:
	draw_cells(data.cells)


func get_base_map() -> AnimatedAutotile:
	if maps.floor and maps.floor.is_inside_tree():
		return maps.floor
	else:
		return AnimatedAutotile.new()


#func draw_door(door_position:Vector2) -> void:
#	pass
#
#
#func draw_window(window_position:Vector2) -> void:
#	pass
#
#
#func draw_dust_particles(cells:Array) -> void:
#	pass

