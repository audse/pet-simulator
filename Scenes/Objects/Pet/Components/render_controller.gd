class_name PetRenderController
extends Node

var data:PetData setget set_data, get_data

onready var input:PetInputRenderer = $InputRenderer


func _init(data_value:PetData=data) -> void:
	data = data_value


func set_data(data_value:PetData) -> void:
	data = data_value
	
	if is_inside_tree() and is_instance_valid(input):
		(input as PetInputRenderer).data = data


func get_data() -> PetData:
	return data
