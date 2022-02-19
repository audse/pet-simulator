class_name BuildingMapComponent
extends BuildingComponent

var DustParticlesScene:PackedScene = preload("res://Assets/Particles/tscn/DustCircleParticles.tscn")
var MaskedMapScene:PackedScene = preload("res://Scenes/Build/Structure/StructureMap/MaskedMap.tscn")
var queue:Queue = Queue.new()

var maps:Dictionary = {}

func _init(
	data_value:BuildingData,
	input_value:BuildingInput,
	tile_manager:BuildingTileManager
).(data_value, input_value, tile_manager) -> void:
	pass


func _enter_tree() -> void:
	queue.setup(self, true)


func draw_cells(cells:Array, draw_dust:bool=false) -> void:
	for map in maps.values():
		if map.is_inside_tree():
			for cell in cells:
				map.set_cellv(cell, 0)
			
			if map.has_method("update_bitmask_region"):
				map.update_bitmask_region()
	
	if draw_dust:
		draw_dust_particles(cells, 12, tile_manager.Action.SET_CELLS)


func erase_cells(cells:Array, draw_dust:bool=false) -> void:
	for map in maps.values():
		if map.is_inside_tree():
			for cell in cells:
				map.set_cellv(cell, -1)
			
			if map.has_method("update_bitmask_region"):
				map.update_bitmask_region()
				
	if draw_dust:
		draw_dust_particles(cells, 12, tile_manager.Action.ERASE_CELLS)


func slide_draw_cells(cells:Array, draw_dust:bool=true) -> void:
	for map in maps.values():
		if map.is_inside_tree():
			map.slide_set_cells(cells)
			
	if maps.floor and maps.floor.is_inside_tree():
		yield(maps.floor, "slide_finished")
	
	if draw_dust:
		draw_dust_particles(cells, 12, tile_manager.Action.SET_CELLS)
	
	yield(get_tree(), "idle_frame")


func slide_erase_cells(cells:Array, draw_dust:bool=true) -> void:
	for map in maps.values():
		if map.is_inside_tree():
			map.slide_erase_cells(cells)
			
	if maps.floor and maps.floor.is_inside_tree():
		yield(maps.floor, "slide_finished")
	
	if draw_dust:
		draw_dust_particles(cells, 12, tile_manager.Action.ERASE_CELLS)
	
	yield(get_tree(), "idle_frame")


func slide_add_to_direction(direction:int, num_additions:int, draw_dust:bool=true) -> void:
	for map in maps.values():
		if map.is_inside_tree():
			map.slide_add_to_direction(direction, num_additions)
			
	if maps.floor and maps.floor.is_inside_tree():
		yield(maps.floor, "slide_finished")
	
	if draw_dust:
		var action:int = (
			tile_manager.Action.SET_CELLS 
			if num_additions > 0 
			else tile_manager.Action.ERASE_CELLS
		)
		draw_dust_particles(tile_manager.base_map.add_to_direction(direction, num_additions), 12, action)
	
	yield(get_tree(), "idle_frame")


func draw_dust_particles(cells:Array, amount:int=12, action:int=tile_manager.Action.SET_CELLS) -> void:
	var dust_particles:Array = []
	
	var dust_cells:Array = tile_manager.parse_animated_cell_array(cells, action)
	
	
	# Draw dust in each cell
	for cell in dust_cells:
		
		# Create instance of dust particles scene
		var new_dust:Particles2D = DustParticlesScene.instance()
		
		# Position on top of cell
		var dust_position:Vector2 = tile_manager.base_map.map_to_world(cell)
		var dust_map_offset:Vector2 = Vector2(
				tile_manager.base_map.cell_size.x / 2,
				tile_manager.base_map.cell_size.y / 2
		)
		new_dust.position = dust_position + dust_map_offset
		add_child(new_dust)
		
		# Start emitting
		new_dust.amount = amount
		new_dust.emitting = true
		
		dust_particles.append(new_dust)

	# Wait for all dust to be finished animating
	yield(Timers.wait(1.5), "completed")
	for node in dust_particles:
		# Delete all dust
		node.queue_free()


func fade_exit_all() -> void:
	for map in maps.values():
		if map is TileMap:
			fade_exit(map)


func fade_exit(map:TileMap) -> void:
	yield(Tweens.tween(map, "modulate:a", map.modulate.a, 0, 0.25), "completed")
	yield(get_tree(), "idle_frame")
	visible = false
	modulate.a = 0
