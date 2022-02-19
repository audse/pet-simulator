class_name Building
extends Node2D

var _connect

var data:BuildingData
var input:BuildingInput
var tile_manager:BuildingTileManager

onready var components:Dictionary = {
	input = null,
	render_controller = null,
}


func _init(data_value:BuildingData=BuildingData.new()) -> void:
	data = data_value
	input = BuildingInput.new()	
	tile_manager = BuildingTileManager.new()


func _ready() -> void:
	
	# Set up rendering
	components.render_controller = BuildingRenderController.new(
		data,
		input,
		tile_manager
	)
	add_child(components.render_controller)
	tile_manager.base_map = components.render_controller.get_base_map()
	
	# Set up input handling
	components.input = BuildingInputController.new(
		data,
		input,
		tile_manager
	)
	add_child(components.input)
	_connect = input.connect(
		"set_cells", 
		data, 
		"update_cells", 
		[BuildingTileManager.Action.SET_CELLS]
	)
	
	_connect = input.connect(
		"erase_cells", 
		data, 
		"update_cells", 
		[BuildingTileManager.Action.ERASE_CELLS]
	)
	
	_connect = input.connect(
		"add_to_direction", 
		data, 
		"update_cells_in_direction", 
		[tile_manager.base_map]
	)
	
	_connect = components.render_controller.connect("demolish_finished", self, "demolish")


func demolish() -> void:
	call_deferred("queue_free")
