class_name BuildingsLayerRenderer
extends Node2D

var BuildingScene := preload("res://Scenes/Objects/Building/Building.tscn")

func place_building(coord:Vector2) -> void:
	print("\nBuilding placed at coord ", coord, "!")
	var cells:Array = []
	# create 3x3 building originating at start point
	for y in [coord.y - 1, coord.y, coord.y + 1]:
		for x in [coord.x - 1, coord.x, coord.x + 1]:
			cells.append(Vector2(x, y))
	
	# draw new building
	var new_building:Building = BuildingScene.instance()
	add_child(new_building)
	
	# warning-ignore:unsafe_property_access
	new_building.share_resource.resource = BuildingData.new("new_building", cells)
	
	adjust_building_z_indeces()
	
	# set to be currently editing
	States.Build.target_node = new_building


func adjust_building_z_indeces() -> void:	
	var buildings:Array = get_children()
	buildings.sort_custom(self, "sort_by_tilemap_y")
	var index:int = len(buildings)
	for building in buildings:
		building.z_index = index
		index -= 1


static func sort_by_tilemap_y(a:Building, b:Building) -> bool:
	var a_map:AnimatedAutotile = (a.data as BuildingData).tile_manager.base_map
	var b_map:AnimatedAutotile = (b.data as BuildingData).tile_manager.base_map
	if a_map and b_map:
		var a_lowest = a_map.get_furthest_cell_value(Globals.Direction.DOWN)
		var b_lowest = b_map.get_furthest_cell_value(Globals.Direction.DOWN)
		
		# If equal, use the most recent node
		if a_lowest == b_lowest:
			return a.get_position_in_parent() > b.get_position_in_parent()
		else:
			return a_lowest > b_lowest
	else:
		return false


func draw_save_data(save_data:Dictionary) -> void:
	if save_data.has("buildings"):
		# Draw each building
		for building in save_data["buildings"]:
			# warning-ignore:unsafe_cast
			if (building as Dictionary).has_all(["id", "cells", "doors", "windows", "design"]):
				var new_building:Building = BuildingScene.instance()
				add_child(new_building, true)
				
				# warning-ignore:unsafe_property_access
				new_building.share_resource.resource = BuildingData.new(
					building["id"],
					building["cells"],
					building["doors"],
					building["windows"],
					building["design"]
				)
			
		# Adjust z ordering
		adjust_building_z_indeces()


func collect_save_data() -> Dictionary:
	# Get save data from each building
	var building_save_data:Array = []
	for building in get_children():
		if building is Building:
			building_save_data.append(building.data.collect_save_data())
	return {
		"version": "build.0.1",
		"buildings": building_save_data
	}
