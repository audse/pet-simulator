class_name BuildingRenderController
extends BuildingComponent

signal demolish_finished

enum DrawMode {
	BASE_ONLY,
	DESIGN_ONLY,
	BASE_AND_DESIGN,
	ALL,
}

var base_renderer:BuildingBaseRenderer
var design_renderer:BuildingDesignRenderer
var draw_mode:int = DrawMode.BASE_ONLY

func _init(
	data_value:BuildingData,
	input_value:BuildingInput,
	tile_manager:BuildingTileManager
).(data_value, input_value, tile_manager) -> void:
	
	base_renderer = BuildingBaseRenderer.new(
		data,
		input,
		tile_manager
	)
	design_renderer = BuildingDesignRenderer.new(
		data,
		input,
		tile_manager
	)


func _enter_tree() -> void:
	add_child(base_renderer)
	add_child(design_renderer)


func _ready() -> void:
	draw_cells(data.cells)
#	draw_test_data()
	
	_connect = input.connect("set_cells", self, "slide_draw_cells")
	_connect = input.connect("erase_cells", self, "slide_erase_cells")
	_connect = input.connect("add_to_direction", self, "slide_add_to_direction")
	
	_connect = input.connect("input_destroyed", self, "demolish")


func get_base_map() -> AnimatedAutotile:
	match draw_mode:
		DrawMode.BASE_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			if base_renderer and base_renderer.is_inside_tree():
				return base_renderer.get_base_map()
		
		DrawMode.DESIGN_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			if design_renderer and design_renderer.is_inside_tree():
				return design_renderer.get_base_map()
	
	return AnimatedAutotile.new()


func draw_cells(cells:Array) -> void:
	printt("drawing", cells)
	match draw_mode:
		DrawMode.BASE_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			base_renderer.draw_cells(cells)
			continue
		DrawMode.DESIGN_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			design_renderer.draw_cells(cells)
			continue


func erase_cells(cells:Array) -> void:
	match draw_mode:
		DrawMode.BASE_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			base_renderer.erase_cells(cells)
			continue
		DrawMode.DESIGN_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			design_renderer.erase_cells(cells)
			continue


func slide_draw_cells(cells:Array) -> void:
	match draw_mode:
		DrawMode.BASE_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			base_renderer.slide_draw_cells(cells)
			continue
		DrawMode.DESIGN_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			design_renderer.slide_draw_cells(cells)
			continue
	
	if tile_manager.base_map:
		yield(Timers.wait(0.4), "completed")
		tile_manager.emit_signal("slide_finished")


func slide_erase_cells(cells:Array) -> void:
	match draw_mode:
		DrawMode.BASE_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			base_renderer.slide_erase_cells(cells)
			continue
		DrawMode.DESIGN_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			design_renderer.slide_erase_cells(cells)
			continue
	
	if tile_manager.base_map:
		yield(Timers.wait(0.4), "completed")
		tile_manager.emit_signal("slide_finished")


func slide_add_to_direction(direction:int, num_additions:int) -> void:
	match draw_mode:
		DrawMode.BASE_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			base_renderer.slide_add_to_direction(direction, num_additions)
			continue
		DrawMode.DESIGN_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			design_renderer.slide_add_to_direction(direction, num_additions)
			continue
	
	if tile_manager.base_map:
		yield(Timers.wait(0.4), "completed")
		tile_manager.emit_signal("slide_finished")


func demolish() -> void:
	match draw_mode:
		DrawMode.BASE_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			base_renderer.draw_dust_particles(tile_manager.base_map.get_used_cells())
			base_renderer.fade_exit_all()
			continue
		DrawMode.DESIGN_ONLY, DrawMode.BASE_AND_DESIGN, DrawMode.ALL:
			design_renderer.draw_dust_particles(tile_manager.base_map.get_used_cells())
			design_renderer.fade_exit_all()
			continue
	
	# Wait for all animations finished
	yield(Timers.wait(1.5), "completed")
	emit_signal("demolish_finished")


func draw_test_data() -> void:
	var cells:Array = []
	for x in range(5, 15):
		for y in range(5, 12):
			cells.append({
				from = Vector2(x, y-1),
				to = Vector2(x, y)
			})
	
	yield(Timers.wait(0.5), "completed")
	slide_draw_cells(cells)
	
	
	yield(Timers.wait(0.75), "completed")
	cells = []
	for x in range(7, 12):
		for y in range(12, 15):
			cells.append({
				from = Vector2(x, y-1),
				to = Vector2(x, y)
			})
	slide_draw_cells(cells)
