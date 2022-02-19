class_name DesignResourceManager
extends ResourceManager

var shaders:Dictionary = {
	clipping_mask = preload("res://Assets/Shaders/clipping_mask.gdshader"),
	mask = preload("res://Assets/Shaders/mask.gdshader"),
	extract_white = preload("res://Assets/Shaders/extract_white.gdshader")
}

var base_tile_sets:Dictionary = {
	floor = preload("res://Assets/Tiles/Build/tres/floor_24x24_tile_set.tres"),
	walls = preload("res://Assets/Tiles/Build/tres/structure_24x72_tile_set.tres"),
	roof = preload("res://Assets/Tiles/Build/tres/roof_24x48_tile_set_2.tres")
}

var texture_manager:DesignTextureManager = DesignTextureManager.new()
var tile_set_generator:TileSetGenerator = TileSetGenerator.new()

var cell_size:Vector2 = Vector2(24, 24)


var empty_design:Dictionary = {
	exterior = {
		id = "default",
		option = "default"
	},
	floor = {
		id = "default",
		option = "default"
	},
	interior = {
		id = "default",
		option = "default"
	},
	roof = {
		id = "default",
		option = "default"
	},
	door = {
		id = "default",
		option = "default"
	},
	window = {
		id = "default",
		option = "default"
	},
}
