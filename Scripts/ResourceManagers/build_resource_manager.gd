class_name BuildResourceManager
extends ResourceManager

var shaders:Dictionary = {
	clipping_mask = preload("res://Assets/Shaders/clipping_mask.gdshader"),
	mask = preload("res://Assets/Shaders/mask.gdshader"),
	extract_white = preload("res://Assets/Shaders/extract_white.gdshader")
}

var textures:Dictionary = {
	door = {
		default = preload("res://Assets/Tiles/Build/png/door_basic_24x72_tile.png"),
		mask = preload("res://Assets/Tiles/Build/png/door_basic_mask_24x72_tile.png")
	},
	window = {
		default = preload("res://Assets/Tiles/Build/png/window_basic_24x72_tile.png"),
		mask = preload("res://Assets/Tiles/Build/png/window_basic_mask_24x72_tile.png")
	}
}

#var tile_sets:Dictionary = {
#	floor = preload("res://Assets/Tiles/Build/tres/floor_24x24_tile_set.tres"),
#	walls = preload("res://Assets/Tiles/Build/tres/structure_24x72_tile_set.tres"),
#	roof = preload("res://Assets/Tiles/Build/tres/roof_24x48_tile_set_2.tres")
#}

var tile_sets:Dictionary = {
	floor = preload("res://Assets/Tiles/Build/tres/building_isometric_tile_set.tres").duplicate(),
	walls = preload("res://Assets/Tiles/Build/tres/building_isometric_tile_set.tres").duplicate(),
	roof = preload("res://Assets/Tiles/Build/tres/building_isometric_tile_set.tres").duplicate()
}

#var cell_size:Vector2 = Vector2(24, 24)
var cell_size:Vector2 = Vector2(48, 24)


func _init() -> void:
	tile_sets.walls.tile_set_texture(0, load("res://Assets/Tiles/Design/Interior/png/wallpaper/elegant_stripe_brown_200_masked.png"))
	tile_sets.floor.tile_set_texture(0, load("res://Assets/Tiles/Design/Floors/png/carpet/little_lines_brown_200_masked.png"))
#	tile_sets.roof.tile_set_texture(0, load("res://Assets/Tiles/Design/Interior/png/wallpaper/elegant_stripe_brown_200_masked.png"))
	pass


func create_sprite(texture:Texture) -> Sprite:
	var new_sprite:Sprite = Sprite.new()
	new_sprite.texture = texture
	new_sprite.centered = false
	return new_sprite
