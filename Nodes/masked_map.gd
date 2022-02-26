class_name MaskedMap
extends BackBufferCopy

signal slide_finished
var _connect

export (Shader) var mask_shader = preload("res://Assets/Shaders/mask.gdshader")
export (TileSet) var base_tile_set
export (TileSet) var mask_tile_set

export (bool) var is_dissolved_on_start:bool = false
export (bool) var uses_mask:bool = true
export (bool) var uses_base_map:bool = true

var MaskViewportScene:PackedScene = preload("res://Nodes/MaskViewport/MaskViewport.tscn")

onready var nodes:Dictionary = {
	base_map = $BaseMap,
	mask_map = null,
	dissolver = Dissolver.new(),
}

var cell_size:Vector2 = Vector2(24, 24)
var tile_set_generator:TileSetGenerator = TileSetGenerator.new(cell_size)

func setup(
	mask_shader_value:Shader=mask_shader,
	base_tile_set_value:TileSet=base_tile_set,
	mask_tile_set_value:TileSet=mask_tile_set,
	cell_size_value:Vector2=cell_size,
	uses_mask_value:bool=uses_mask,
	uses_base_map_value:bool=uses_base_map,
	is_dissolved_on_start_value:bool=is_dissolved_on_start
) -> void:
	mask_shader = mask_shader_value
	base_tile_set = base_tile_set_value
	mask_tile_set = mask_tile_set_value
	uses_mask = uses_mask_value
	uses_base_map = uses_base_map_value
	is_dissolved_on_start = is_dissolved_on_start_value
	
	cell_size = cell_size_value
	tile_set_generator = TileSetGenerator.new(cell_size)


func _ready() -> void:
	# Set up dissolver
	nodes.dissolver.is_dissolved_on_start = false
	add_child(nodes.dissolver)
	
	# Set tile maps
	nodes.base_map.tile_set = base_tile_set
	if uses_mask:
		nodes.mask_map = create_ghost_mask(mask_shader, mask_tile_set)
	
	# Hide unneeded maps
	if uses_base_map:
		nodes.base_map.visible = true
	else:
		nodes.base_map.visible = false


func set_base_tile_set(tile_set:TileSet) -> void:
	nodes.base_map.tile_set = tile_set


func get_base_tile_set() -> TileSet:
	return nodes.base_map.tile_set


func set_mask_tile_set(tile_set:TileSet) -> void:
	if nodes.mask_map:
		nodes.mask_map.tile_set = tile_set


func get_mask_tile_set() -> TileSet:
	if nodes.mask_map:
		return nodes.mask_map.tile_set
	else:
		return nodes.base_map.tile_set


func create_mask(shader:Shader) -> MaskViewport:
	var new_mask:MaskViewport = MaskViewportScene.instance()
	add_child(new_mask)
	new_mask.mask_shader = shader
	
	return new_mask


func create_ghost_mask(shader:Shader, tile_set:TileSet) -> AnimatedAutotile:
	var ghost_map:AnimatedAutotile = nodes.base_map.duplicate()
	
	var new_mask:MaskViewport = create_mask(shader)
	new_mask.nodes.viewport.add_child(ghost_map)
	
	ghost_map.tile_set = tile_set
	ghost_map.add_to_group("ghost_maps")
	
	return ghost_map


func create_and_set_design_tile_set(texture:Texture) -> void:
	nodes.base_map.tile_set = tile_set_generator.create_tile_set(texture, uses_mask, mask_tile_set)
	nodes.base_map.update_bitmask_region()


func set_cell(x:int, y:int, index:int=0) -> void:
	for map in get_all_maps():
		map.set_cell(x, y, index)
		if map.tile_set:
			map.update_bitmask_region()


func set_cellv(cell:Vector2, index:int=0) -> void:
	set_cell(cell.x, cell.y, index)


func slide_set_cells(cells_to_set:Array) -> void:
	flash_base_map()
	var base_map
	for map in get_all_maps():
		base_map = map
		map.slide_set_cells(cells_to_set)
	
	if base_map is AnimatedAutotile:
		yield(base_map, "slide_finished")
	else:
		yield(get_tree(), "idle_frame")
	emit_signal("slide_finished")


func slide_erase_cells(cells_to_erase:Array) -> void:
	flash_base_map()
	var base_map
	for map in get_all_maps():
		base_map = map
		map.slide_erase_cells(cells_to_erase)
		
	if base_map is AnimatedAutotile:
		yield(base_map, "slide_finished")
	else:
		yield(get_tree(), "idle_frame")
	emit_signal("slide_finished")


func slide_add_to_direction(direction:int, num_additions:int) -> void:
	flash_base_map()
	var base_map
	for map in get_all_maps():
		base_map = map
		map.slide_add_to_direction(direction, num_additions)
		
	if base_map is AnimatedAutotile:
		yield(base_map, "slide_finished")
	else:
		yield(get_tree(), "idle_frame")
	emit_signal("slide_finished")


func get_all_maps() -> Array:
	var maps:Array = [nodes.base_map]
	maps.append_array(Globals.get_children_in_group(self, "ghost_maps"))
	return maps


func flash_base_map() -> void:
	if uses_base_map:
		Tweens.tween(nodes.base_map, "modulate:a", 1, 0.8, 0.25)
		Tweens.delay_tween(nodes.base_map, "modulate:a", 0.8, 1, 0.25, 0.35)


func fade_enter() -> void:
	visible = true
	Tweens.tween(self, "modulate:a", modulate.a, 1, 0.25)
	yield(Tweens.tween(self, "modulate:a", modulate.a, 1, 0.25), "completed")
	yield(get_tree(), "idle_frame")


func fade_exit() -> void:
	Tweens.tween(self, "modulate:a", modulate.a, 0, 0.25)
	yield(Tweens.tween(self, "modulate:a", modulate.a, 0, 0.25), "completed")
	yield(get_tree(), "idle_frame")
	visible = false
	modulate.a = 0
