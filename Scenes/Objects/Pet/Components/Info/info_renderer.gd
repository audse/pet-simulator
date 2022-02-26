class_name PetInfoRenderer
extends Control


var data:PetData setget set_data, get_data


onready var components:Dictionary = {
	needs = find_node("NeedsRenderer"),
	personality = find_node("PersonalityRenderer"),
}


func set_data(data_value:PetData) -> void:
	data = data_value
	components.needs.data = data.needs_data
	components.personality.data = data.personality_data


func get_data() -> PetData:
	return data
