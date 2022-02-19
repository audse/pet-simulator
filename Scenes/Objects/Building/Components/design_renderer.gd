class_name BuildingDesignRenderer
extends BuildingMapComponent

var resource_manager:DesignResourceManager = DesignResourceManager.new()


func _init(
	data_value:BuildingData,
	input_value:BuildingInput,
	tile_manager:BuildingTileManager
).(data_value, input_value, tile_manager) -> void:
	maps = {
		exterior = MaskedMapScene.instance(),
		floor = MaskedMapScene.instance(),
		interior = MaskedMapScene.instance(),
		roof = MaskedMapScene.instance(),
		wall_tops = MaskedMapScene.instance()
	}
	
	maps.exterior.setup(
		resource_manager.shaders.clipping_mask,
		resource_manager.base_tile_sets.walls,
		resource_manager.base_tile_sets.walls,
		resource_manager.cell_size,
		false
	)
	maps.floor.setup(
		resource_manager.shaders.clipping_mask,
		resource_manager.base_tile_sets.floor,
		resource_manager.base_tile_sets.floor,
		resource_manager.cell_size,
		true
	)
	maps.interior.setup(
		resource_manager.shaders.clipping_mask,
		resource_manager.base_tile_sets.walls,
		resource_manager.base_tile_sets.walls,
		resource_manager.cell_size,
		false
	)
	maps.roof.setup(
		resource_manager.shaders.clipping_mask,
		resource_manager.base_tile_sets.roof,
		resource_manager.base_tile_sets.roof,
		resource_manager.cell_size,
		false
	)
	maps.wall_tops.setup(
		resource_manager.shaders.extract_white,
		resource_manager.base_tile_sets.walls,
		resource_manager.base_tile_sets.walls,
		resource_manager.cell_size,
		true,
		false
	)
	
	maps.roof.position.y = -36


func _enter_tree() -> void:
	for map in [maps.floor, maps.interior, maps.exterior, maps.wall_tops, maps.roof]:
		add_child(map)
	

func _ready() -> void:
	set_designs()


func get_base_map() -> AnimatedAutotile:
	if maps.floor and maps.floor.is_inside_tree():
		return maps.floor
	else:
		return AnimatedAutotile.new()


func set_designs(designs_dict:Dictionary=data.design) -> void:
	var map_keys:Array = ["exterior", "floor", "interior", "roof"]
	
	for key in designs_dict.keys():
		var is_valid_design:bool = designs_dict[key].has_all(["id", "option"])
		var is_not_default:bool = designs_dict[key]["id"] != "default"
		
		if key in map_keys and is_valid_design and is_not_default:
			set_design(key, designs_dict[key].id, designs_dict[key].option)


func set_design(type:String, id:String, option:String) -> void:
	var texture:Texture = resource_manager.texture_manager.find_texture(
			id, option
	)
	if maps[type]:
		maps[type].create_and_set_design_tile_set(texture)
