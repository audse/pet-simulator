tool
class_name PersonalityRenderer
extends MarginContainer

export (Resource) var data setget set_data, get_data
export (StyleBoxFlat) var empty_style_box setget set_empty_style_box, get_empty_style_box
export (StyleBoxFlat) var filled_style_box setget set_filled_style_box, get_filled_style_box


func _ready() -> void:
	update_values()


func update_values() -> void:
	if data and data is PersonalityData:
		var active_renderer:PersonalityValueGroupRenderer = find_node("ActiveGroupRenderer")
		var clean_renderer:PersonalityValueGroupRenderer = find_node("CleanGroupRenderer")
		var playful_renderer:PersonalityValueGroupRenderer = find_node("PlayfulGroupRenderer")
		var smart_renderer:PersonalityValueGroupRenderer = find_node("SmartGroupRenderer")
		var social_renderer:PersonalityValueGroupRenderer = find_node("SocialGroupRenderer")
		
		if active_renderer:
			active_renderer.value = data.active
		
		if clean_renderer:
			clean_renderer.value = data.clean
		
		if playful_renderer:
			playful_renderer.value = data.playful
		
		if smart_renderer:
			smart_renderer.value = data.smart
		
		if social_renderer:
			social_renderer.value = data.social


func set_data(data_value:PersonalityData) -> void:
	data = data_value
	update_values()


func get_data() -> PersonalityData:
	return data


func set_empty_style_box(new_style_box:StyleBox) -> void:
	empty_style_box = new_style_box
	
	var values_container:Node = find_node("PersonalityValuesContainer")
	if values_container:
		for node in values_container.get_children():
			if node is PersonalityValueGroupRenderer:
				node.empty_style_box = empty_style_box


func get_empty_style_box() -> StyleBox:
	return empty_style_box


func set_filled_style_box(new_style_box:StyleBox) -> void:
	filled_style_box = new_style_box
	
	var values_container:Node = find_node("PersonalityValuesContainer")
	if values_container:
		for node in values_container.get_children():
			if node is PersonalityValueGroupRenderer:
				node.filled_style_box = filled_style_box


func get_filled_style_box() -> StyleBox:
	return filled_style_box

