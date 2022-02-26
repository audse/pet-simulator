class_name MapComponent extends AnimatedAutotile

var DustParticlesScene:PackedScene = preload("res://Assets/Particles/tscn/DustCircleParticles.tscn")


func draw_cells(cells:Array, draw_dust:bool=false) -> void:
	if is_inside_tree():
		for cell in cells:
			set_cellv(cell, 0)
		update_bitmask_region()
	if draw_dust:
		draw_dust_particles(cells, 12, TileMapRef.Action.SET_CELLS)


func erase_cells(cells:Array, draw_dust:bool=false) -> void:
	if is_inside_tree():
		for cell in cells:
			set_cellv(cell, -1)
		update_bitmask_region()	
	if draw_dust:
		draw_dust_particles(cells, 12, TileMapRef.Action.ERASE_CELLS)


func slide_set_cells(cells:Array, time:float=0.35, draw_dust:bool=true) -> void:
	if is_inside_tree():
		.slide_set_cells(cells, time)
	yield(self, "slide_finished")
	if draw_dust:
		draw_dust_particles(cells, 12, TileMapRef.Action.SET_CELLS)
	yield(get_tree(), "idle_frame")


func slide_erase_cells(cells:Array, time:float=0.35, draw_dust:bool=true) -> void:
	if is_inside_tree():
		.slide_erase_cells(cells, time)
	yield(self, "slide_finished")
	if draw_dust:
		draw_dust_particles(cells, 12, TileMapRef.Action.ERASE_CELLS)
	yield(get_tree(), "idle_frame")


func slide_add_to_direction(
	direction:int=Globals.Direction.UP, 
	num_additions:int=1, 
	time:float=0.35, 
	draw_dust:bool=true
) -> void:
	if is_inside_tree():
		.slide_add_to_direction(direction, num_additions, time)
		
	yield(self, "slide_finished")
	
	if draw_dust:
		var action:int = (
			TileMapRef.Action.SET_CELLS 
			if num_additions > 0 
			else TileMapRef.Action.ERASE_CELLS
		)
		draw_dust_particles(add_to_direction(direction, num_additions), 12, action)
	
	yield(get_tree(), "idle_frame")


func draw_dust_particles(cells:Array, amount:int=12, action:int=TileMapRef.Action.SET_CELLS) -> void:
	var dust_particles:Array = []
	var dust_cells:Array = TileMapRef.parse_animated_cell_array(cells, action)
	
	# Draw dust in each cell
	for cell in dust_cells:
		
		# Create instance of dust particles scene
		var new_dust:Particles2D = DustParticlesScene.instance()
		
		# Position on top of cell
		var dust_position:Vector2 = map_to_world(cell)
		var dust_map_offset:Vector2 = Vector2(
				cell_size.x / 2,
				cell_size.y / 2
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


func fade_exit() -> void:
	yield(Tweens.tween(self, "modulate:a", modulate.a, 0, 0.25), "completed")
	yield(get_tree(), "idle_frame")
	visible = false
	modulate.a = 0
