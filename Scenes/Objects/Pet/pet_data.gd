class_name PetData
extends Resource

var name:String
var birthday:String

var animal_data:AnimalData
var needs_data:NeedsData
var personality_data:PersonalityData
var action_data:PetActionsData


func _init(
	random:bool=false,
	name_value:String=name,
	birthday_value:String=birthday,
	animal_data_value:AnimalData=AnimalData.new(),
	needs_data_value=NeedsData.new(),
	personality_data_value=PersonalityData.new(),
	actions_data_value=PetActionsData.new()
) -> void:
	name = name_value
	birthday = birthday_value
	animal_data = animal_data_value
	needs_data = needs_data_value
	personality_data = personality_data_value
	action_data = actions_data_value
	
	if random:
		needs_data.generate_random()
		personality_data.generate_random()
