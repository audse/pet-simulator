class_name PetData
extends Resource

var needs_data:NeedsData
var personality_data:PersonalityData
var action_data:PetActionsData


func _init(
	random:bool=false,
	needs_data_value=NeedsData.new(),
	personality_data_value=PersonalityData.new(),
	actions_data_value=PetActionsData.new()
) -> void:
	needs_data = needs_data_value
	personality_data = personality_data_value
	action_data = actions_data_value
	
	if random:
		needs_data.generate_random()
		personality_data.generate_random()
