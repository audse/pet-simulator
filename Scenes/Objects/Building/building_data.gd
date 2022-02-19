class_name BuildingData
extends Resource

var id:String = ""
var cells:Array = []
var doors:Array = []
var windows:Array = []

var design:Dictionary = {
	exterior = {
		id = "post_large_siding",
		option = "grey_200"
	},
	floor = {
		id = "basic_hardwood",
		option = "brown_500"
	},
	interior = {
		id = "ornate_bright",
		option = "orange_500"
	},
	roof = {
		id = "simple_shingle",
		option = "grey_600"
	},
	door = {},
	window = {}
}


func _init(
		id_value:String=id,
		cells_value:Array=cells,
		doors_value:Array=doors,
		windows_value:Array=windows,
		design_value:Dictionary=design
) -> void:
	id = id_value
	cells = cells_value
	doors = doors_value
	windows = windows_value
	design = design_value


func update_cells(changed_cells, action:int) -> void:
	match action:
		BuildingTileManager.Action.SET_CELLS:
			for cell in changed_cells:
				cells.append(cell.to)
		BuildingTileManager.Action.ERASE_CELLS:
			for cell in changed_cells:
				cells.erase(cell.from)


func update_cells_in_direction(direction:int, num_additions:int, base_map:AnimatedAutotile) -> void:
	var changed_cells:Array = base_map.add_to_direction(direction, num_additions)
	if num_additions > 0:
		for cell in changed_cells:
			cells.append(cell.to)
	else:
		for cell in changed_cells:
			cells.erase(cell.from)


func collect_save_data() -> Dictionary:
	return {
		"id": id,
		"cells": cells,
		"doors": doors,
		"windows": windows,
		"design": design
	}
