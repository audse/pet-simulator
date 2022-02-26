class_name BuildingRenderController
extends BuildingComponent

signal demolish_finished

onready var autotiler:Autotiler = $Autotiler
onready var base_map:AnimatedAutotile = $BaseMap


func _ready() -> void:
	_connect = autotiler.connect("tile_set_texture_created", self, "_on_tile_set_texture_created")
	
	autotiler.create_layered_tile_set_texture([
		preload("res://Assets/Tiles/Design/Floor/png/simple_carpet_reduced.png"),
		preload("res://Assets/Tiles/Design/Interior/paint/png/simple_trim_paint_reduced.png"),
		preload("res://Assets/Tiles/Design/Exterior/png/plaster_running_brick_reduced.png"),
		preload("res://Assets/Tiles/Design/shadow_isometric_reduced.png")
	])


func set_data(data_value:BuildingData) -> void:
	.set_data(data_value)
	
	draw_cells(data_value.cells)

	_connect = data.input.connect("set_cells", self, "slide_draw_cells")
	_connect = data.input.connect("erase_cells", self, "slide_erase_cells")
	_connect = data.input.connect("add_to_direction", self, "slide_add_to_direction")
	_connect = data.input.connect("input_destroyed", self, "demolish")


func get_base_map() -> AnimatedAutotile:
	return base_map


func draw_cells(cells:Array) -> void:
	(base_map as MapComponent).draw_cells(cells)


func erase_cells(cells:Array) -> void:
	(base_map as MapComponent).erase_cells(cells)


func slide_draw_cells(cells:Array) -> void:
	base_map.slide_set_cells(cells)
	yield(base_map, "slide_finished")
	if data.tile_manager:
		data.tile_manager.emit_signal("slide_finished")


func slide_erase_cells(cells:Array) -> void:
	base_map.slide_erase_cells(cells)
	yield(base_map, "slide_finished")
	if data.tile_manager:
		data.tile_manager.emit_signal("slide_finished")


func slide_add_to_direction(direction:int, num_additions:int) -> void:
	base_map.slide_add_to_direction(direction, num_additions)
	yield(base_map, "slide_finished")
	if data.tile_manager:
		data.tile_manager.emit_signal("slide_finished")


func demolish() -> void:
	(base_map as MapComponent).draw_dust_particles(base_map.get_used_cells())
	(base_map as MapComponent).fade_exit()
	# Wait for all animations finished
	yield(Timers.wait(1.5), "completed")
	emit_signal("demolish_finished")


func _on_tile_set_texture_created(texture:ImageTexture) -> void:
	base_map.tile_set = base_map.tile_set.duplicate()
	base_map.tile_set.tile_set_texture(0, texture)
