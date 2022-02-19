class_name TileMapGroup
extends Resource

var base_map
var maps:Array

func _init(map_list:Array) -> void:
	for map in map_list:
		if map is TileMap or map is MaskedMap:
			maps.append(map)
	
	if len(maps) > 0:
		base_map = maps[0]


func get_used_cells() -> Array:
	return base_map.get_used_cells()


func get_used_rect() -> Rect2:
	return base_map.get_used_rect()


func set_cell(x:int, y:int, index:int=0) -> void:
	printt("setting...", maps)
	for map in maps:
		map.set_cell(x, y, index)
		if map.has_method("update_bitmask_region"):
			map.update_bitmask_region()


func set_cellv(cell:Vector2, index:int=0) -> void:
	for map in maps:
		map.set_cellv(cell, index)
		if map.has_method("update_bitmask_region"):
			map.update_bitmask_region()


func slide_set_cells(cells_to_set:Array) -> void:
	var animated_base_map
	for map in maps:
		if map.has_signal("slide_finished"):
			animated_base_map = map
			map.slide_set_cells(cells_to_set)
	
	if animated_base_map and animated_base_map.has_signal("slide_finished"):
		yield(animated_base_map, "slide_finished")


func slide_erase_cells(cells_to_erase:Array) -> void:
	var animated_base_map
	for map in maps:
		if map.has_signal("slide_finished"):
			animated_base_map = map
			map.slide_erase_cells(cells_to_erase)
	
	if animated_base_map and animated_base_map.has_signal("slide_finished"):
		yield(animated_base_map, "slide_finished")


func slide_add_to_direction(direction:int, num_additions:int) -> void:
	var animated_base_map
	for map in maps:
		if map.has_signal("slide_finished"):
			animated_base_map = map
			map.slide_add_to_direction(direction, num_additions)
	
	if animated_base_map and animated_base_map.has_signal("slide_finished"):
		yield(animated_base_map, "slide_finished")
