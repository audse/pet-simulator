class_name BuildingComponent
extends Node2D

var _connect

var data:BuildingData
var input:BuildingInput
var tile_manager:BuildingTileManager

func _init(
	data_value:BuildingData,
	input_value:BuildingInput,
	tile_manager_value:BuildingTileManager
) -> void:
	data = data_value
	input = input_value
	tile_manager = tile_manager_value
