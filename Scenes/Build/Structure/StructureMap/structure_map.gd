class_name StructureMap
extends Node2D

var _connect

onready var base_map = $BaseFloor
onready var nodes:Dictionary = {
	base_maps = {
		floor = $BaseFloor,
		walls = $BaseWalls,
		roof = $BaseRoof
	},
	masked_maps = {
		floor = $Floor,
		interior = $Interior,
		exterior = $Exterior,
		wall_tops = $WallTops,
		roof = $Roof
	}
}
onready var highlight_map = $Highlight

onready var build_resource_manager:BuildResourceManager = BuildResourceManager.new()
onready var design_texture_manager:DesignTextureManager = DesignTextureManager.new()
onready var view_state:State = State.new(Globals.View.DEFAULT)

var base_map_group:TileMapGroup
var mask_map_group:TileMapGroup
var all_map_group:TileMapGroup

var design:Dictionary = {
	exterior = {
		id = "basic_foundation_siding",
		option = "grey_500"
	},
	floor = {
		id = "basic_hardwood",
		option = "brown_500"
	},
	interior = {
		id = "crown_moulding",
		option = "grey_100"
	},
	roof = {
		id = "simple_shingle",
		option = "grey_600"
	}
}


func _ready() -> void:
	view_state.reset_state = Globals.View.DEFAULT
	view_state.state = Globals.View.DEFAULT
	
	set_designs()
	
	_connect = view_state.connect("enter_state", self, "enter_view_state")

	_connect = States.Design.connect("design_selected", self, "design_selected")
	_connect = States.Design.Selector.connect("enter_state", self, "enter_design_selector_state")
	_connect = States.Design.Selector.connect("exit_state", self, "exit_design_selector_state")
	
	var base_map_array:Array = nodes.base_maps.values()
	var masked_map_array:Array = nodes.masked_maps.values()
	
	base_map_group = TileMapGroup.new(base_map_array)
	mask_map_group = TileMapGroup.new(masked_map_array)
	all_map_group = TileMapGroup.new(base_map_array + masked_map_array)
	


func design_selected(type:String, id:String, option:String) -> void:
	if States.Design.target_node == get_parent():
		set_design(type, id, option)


func enter_design_selector_state(next_state:int) -> void:
	if States.Design.target_node == get_parent():
		match next_state:
			States.Design.ROOF:
				Tweens.tween(nodes.masked_maps.roof, "modulate:a", nodes.masked_maps.roof.modulate.a, 1, 0.5)


func exit_design_selector_state(prev_state:int) -> void:
	if States.Design.target_node == get_parent():
		match prev_state:
			States.Design.ROOF:
				Tweens.tween(nodes.masked_maps.roof, "modulate:a", nodes.masked_maps.roof.modulate.a, 0, 0.5)


func set_designs(designs_dict:Dictionary=design) -> void:
	for key in designs_dict.keys():
		set_design(key, designs_dict[key].id, designs_dict[key].option)


func set_design(type:String, id:String, option:String) -> void:
	design[type] = {
		id = id,
		option = option
	}
	var texture:Texture = design_texture_manager.find_texture(
			id, option
	)
	match type:
		"exterior":
			nodes.masked_maps.exterior.create_and_set_design_tile_set(texture)
		"floor":
			nodes.masked_maps.floor.create_and_set_design_tile_set(texture)
		"interior":
			nodes.masked_maps.interior.create_and_set_design_tile_set(texture)
		"roof":
			nodes.masked_maps.roof.create_and_set_design_tile_set(texture)


func add_door(coords:Vector2) -> void:
	var _door_sprite = add_object(
			coords,
			build_resource_manager.create_sprite(
					build_resource_manager.textures.door.default
			),
			build_resource_manager.create_sprite(
					build_resource_manager.textures.door.mask
			),
			nodes.masked_maps.exterior
	)


func add_window(coords:Vector2, is_exterior:bool) -> void:
	var window_sprite = add_object(
			coords,
			build_resource_manager.create_sprite(
					build_resource_manager.textures.window.default
			),
			build_resource_manager.create_sprite(
					build_resource_manager.textures.window.mask
			),
			nodes.masked_maps.exterior 
			if is_exterior
			else nodes.masked_maps.interior
	) 
	
	if not is_exterior:
		window_sprite.position.y -= 8


func add_object(coords:Vector2, object_sprite:Sprite, mask_sprite:Sprite, map:MaskedMap) -> Sprite:
	
	var object_position:Vector2 = base_map.map_to_world(coords)
	map.add_child(object_sprite)
	
	var mask = map.create_mask(
			build_resource_manager.shaders.mask
	)
	
	mask.nodes.viewport.add_child(mask_sprite)
	
	var texture_size = object_sprite.texture.get_size()
	object_sprite.position = object_position - (texture_size - base_map.cell_size)
	mask_sprite.position = object_position - (texture_size - base_map.cell_size)

	return object_sprite


func enter_view_state(_next_state:int) -> void:
	for map in nodes.masked_maps:
		pass
#		map.toggle_view_state(next_state)


func get_used_cells() -> Array:
	return base_map.get_used_cells()


func toggle_view() -> void:
	match view_state.state:
		Globals.View.DEFAULT:
			view_state.set_to(Globals.View.CUTAWAY)
		Globals.View.CUTAWAY:
			view_state.set_to(Globals.View.DEFAULT)


func enter() -> void:
	var map_array:Array = Globals.get_array_from_dict(nodes)
	for map in map_array:
		map.visible = true
		map.modulate.a = 1


func fade_enter() -> void:	
	for map in nodes.masked_maps.values():
		map.fade_exit()
	
	for map in nodes.base_maps.values():
		map.visible = true
		Tweens.tween(map, "modulate:a", map.modulate.a, 1, 0.25)
	
	yield(Timers.wait(0.25), "completed")	
	yield(get_tree(), "idle_frame")


func exit() -> void:
	var map_array:Array = Globals.get_array_from_dict(nodes)
	for map in map_array:
		map.visible = false
		map.modulate.a = 0


func fade_exit() -> void:
	for map in nodes.masked_maps.values():
		map.fade_exit()
	
	for map in nodes.base_maps.values():
		Tweens.tween(map, "modulate:a", map.modulate.a, 0, 0.25)
	
	yield(Timers.wait(0.25), "completed")
	
	for map in nodes.base_maps.values():
		map.visible = false


var exterior_autotile_coords:Array = [
	Vector2(0, 2),
	Vector2(0, 3),
	Vector2(1, 2),
	Vector2(2, 2),
	Vector2(3, 2),
	Vector2(0, 3),
	Vector2(1, 3),
	Vector2(2, 3),
	Vector2(3, 3),
	Vector2(5, 3),
	Vector2(6, 3),
	Vector2(8, 3),
	Vector2(9, 3),
	Vector2(11, 3),
]

func get_exterior_cells() -> Array:
	var exterior_cells:Array = []
	for cell in get_used_cells():
		var autotile_coord:Vector2 = nodes.base_maps.walls.get_cell_autotile_coord(cell.x, cell.y)
		if autotile_coord in exterior_autotile_coords:
			exterior_cells.append(cell)
	
	return exterior_cells


func highlight_cells(cells:Array) -> void:
	highlight_map.clear()
	for cell in cells:
		highlight_map.set_cell(cell.x, cell.y, 0)


func set_cell(x:int, y:int, index:int=0) -> void:
	all_map_group.set_cell(x, y, index)


func set_cellv(cell:Vector2, index:int=0) -> void:
	all_map_group.set_cellv(cell, index)


func slide_set_cells(cells_to_set:Array) -> void:
	yield(all_map_group.slide_set_cells(cells_to_set), "completed")


func slide_erase_cells(cells_to_erase:Array) -> void:
	yield(all_map_group.slide_erase_cells(cells_to_erase), "completed")


func slide_add_to_direction(direction:int, num_additions:int) -> void:
	yield(all_map_group.slide_add_to_direction(direction, num_additions), "completed")
