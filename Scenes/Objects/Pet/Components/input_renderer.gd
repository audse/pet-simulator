class_name PetInputRenderer
extends Control

var _connect

var data:PetData setget set_data, get_data

onready var renderers:Dictionary = {
	action_group = $ActionGroupRenderer,
	info = $InfoRenderer
}


func _init(data_value:PetData=data) -> void:
	data = data_value


func draw_actions(_start_point:Vector2=Vector2.ZERO) -> void:
	if (
		is_inside_tree() 
		and is_instance_valid(renderers.action_group)
		and data
		and data.action_data
	):
		(renderers.action_group as ActionGroupRenderer).draw(data.action_data.actions)


func draw_info() -> void:
	if is_inside_tree() and is_instance_valid(renderers.info):
		(renderers.info as PetInfoRenderer).queue_enter()


func set_data(data_value:PetData) -> void:
	data = data_value
	
	if is_inside_tree() and is_instance_valid(renderers.info) and is_instance_valid(renderers.action_group):
		(renderers.info as PetInfoRenderer).data = data_value
		(renderers.action_group as ActionGroupRenderer).data = data_value


func get_data() -> PetData:
	return data
