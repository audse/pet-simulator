class_name BuildingData
extends Resource

var _connect

var input := BuildingInputData.new()
var tile_manager := BuildingTileManager.new()

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


func collect_save_data() -> Dictionary:
	return {
		"id": id,
		"cells": tile_manager.base_map.get_used_cells(),
		"doors": doors,
		"windows": windows,
		"design": design
	}
