class_name Pet
extends Node

var data:PetData setget set_data, get_data
onready var components:Dictionary = {
	input_controller = $InputController,
	render_controller = $RenderController
}


func _ready() -> void:
	self.data = PetData.new(true)
	
	yield(Timers.wait(1), "completed")
#	components.render_controller.input.draw_info()
#	components.render_controller.input.draw_actions()


func set_data(data_value:PetData) -> void:
	data = data_value
	
	if is_inside_tree():
		if is_instance_valid(components.input_controller):
			(components.input_controller as PetInputController).data = data_value
		if is_instance_valid(components.render_controller):
			(components.render_controller as PetRenderController).data = data_value


func get_data() -> PetData:
	return data
	
