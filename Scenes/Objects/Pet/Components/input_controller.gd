class_name PetInputController
extends Node

var data:PetData setget set_data, get_data


func _init(data_value:PetData=data) -> void:
	data = data_value


func set_data(data_value:PetData) -> void:
	data = data_value


func get_data() -> PetData:
	return data
