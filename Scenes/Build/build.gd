extends Node2D

var _connect

onready var StructureScene:PackedScene = preload("res://Scenes/Build/Structure/Structure.tscn")
onready var nodes:Dictionary = {
	guide_grid = $GuideGrid,
	structures = $Structures,
	placement_guide = $PlacementGuide
}

onready var Saver = Save.new()

func _ready() -> void:
	_connect = States.Build.connect("enter_state", self, "enter_state")
	_connect = States.Build.connect("exit_state", self, "exit_state")
	_connect = States.Design.connect("design_selected", self, "save_data")
	
	_connect = States.Build.connect("build_here_pressed", self, "build_here")
	
	Saver.setup("build_mode")
	draw_save_data(Saver.load_data())


func enter_state(next_state:int) -> void:
	match next_state:
		States.Build.ZERO:
			nodes.guide_grid.exit()
			
		States.Build.READY:
			pass
			
		States.Build.PLACING:
			nodes.guide_grid.activate()
			nodes.placement_guide.start(nodes.guide_grid)
			
		States.Build.EDITING:
			pass
		
		States.Build.DEMOLISHING:
			nodes.guide_grid.activate()


func exit_state(prev_state:int) -> void:
	Saver.save_data(collect_save_data())
	
	match prev_state:
		States.Build.ZERO:
			nodes.guide_grid.enter()
			
		States.Build.READY:
			pass
			
		States.Build.PLACING:
			nodes.guide_grid.deactivate()
			nodes.placement_guide.stop()
			
		States.Build.EDITING:
			pass
		
		States.Build.DEMOLISHING:
			nodes.guide_grid.deactivate()


func save_data(_type:String, _id:String, _option:String) -> void:
	yield(Timers.wait(0.25), "completed")
	Saver.save_data(collect_save_data())


func exit() -> void:
	nodes.placement_guide.stop()
	nodes.guide_grid.stop()


func build_here():
	var coordinates:Vector2 = nodes.guide_grid.world_to_map(
			nodes.placement_guide.position
	)
	add_new_structure(coordinates)


func add_new_structure(coordinates) -> void:
	var new_structure:Structure = StructureScene.instance()
	nodes.structures.add_child(new_structure, true)
	
	new_structure.place_at(
		int(coordinates.x), 
		int(coordinates.y)
	)
	
	adjust_structure_z_indeces()
	
	# Add this new building as the Build states' current target
	States.Build.target_node = new_structure


func adjust_structure_z_indeces() -> void:	
	var structures:Array = nodes.structures.get_children()
	structures.sort_custom(self, "sort_by_tilemap_y")
	var index:int = len(structures)
	for structure in structures:
		structure.z_index = index
		index -= 1


static func sort_by_tilemap_y(a:Node, b:Node) -> bool:
	var a_map = a.base_map
	var b_map = b.base_map
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
	if save_data.has("structures"):
		# Draw each structure
		for structure in save_data["structures"]:
			var new_structure:Structure = StructureScene.instance()
			nodes.structures.add_child(new_structure, true)
			new_structure.draw_save_data(structure)
			
		# Adjust z ordering
		adjust_structure_z_indeces()


func collect_save_data() -> Dictionary:
	# Get save data from each structure
	var structure_save_data:Array = []
	for node in nodes.structures.get_children():
		if node is Structure:
			structure_save_data.append(node.collect_save_data())
	return {
		"version": "build.0.1",
		"structures": structure_save_data
	}
