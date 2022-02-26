class_name Building
extends Node2D

var _connect

var share_resource:ShareResource

var data:BuildingData setget set_data, get_data

onready var components:Dictionary = {
	input_controller = $InputController,
	render_controller = $RenderController,
}


func _ready() -> void:
	_connect = components.render_controller.connect("demolish_finished", self, "demolish")
	
	share_resource = $ShareResource


func demolish() -> void:
	call_deferred("queue_free")


func set_data(data_value:BuildingData) -> void:
	data = data_value
	data.tile_manager.base_map = components.render_controller.get_base_map()


func get_data() -> BuildingData:
	return data
