class_name BuildingComponent
extends Node2D

var _connect

var data:BuildingData setget set_data, get_data


func set_data(data_value:BuildingData) -> void:
	data = data_value


func get_data() -> BuildingData:
	return data
