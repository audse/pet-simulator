class_name BuildResourceManager
extends ResourceManager

const shaders := {
	clipping_mask = preload("res://Assets/Shaders/clipping_mask.gdshader"),
	mask = preload("res://Assets/Shaders/mask.gdshader"),
	extract_white = preload("res://Assets/Shaders/extract_white.gdshader")
}

#var textures:Dictionary = {
#	door = {
#		default = preload("res://Assets/Tiles/Build/png/door_basic_24x72_tile.png"),
#		mask = preload("res://Assets/Tiles/Build/png/door_basic_mask_24x72_tile.png")
#	},
#	window = {
#		default = preload("res://Assets/Tiles/Build/png/window_basic_24x72_tile.png"),
#		mask = preload("res://Assets/Tiles/Build/png/window_basic_mask_24x72_tile.png")
#	}
#}

const tile_sets := {
	floor = preload("res://Assets/Tiles/Build/tres/walls_isometric_50x100_tile_set.tres"),
	walls = preload("res://Assets/Tiles/Build/tres/walls_isometric_50x100_tile_set.tres"),
	interior_walls = preload("res://Assets/Tiles/Build/tres/walls_isometric_50x100_tile_set.tres"),
	roof = preload("res://Assets/Tiles/Build/tres/walls_isometric_50x100_tile_set.tres")
}

const cell_size := Vector2(48, 24)


static func create_sprite(texture:Texture) -> Sprite:
	var new_sprite:Sprite = Sprite.new()
	new_sprite.texture = texture
	new_sprite.centered = false
	return new_sprite

static func get_tile_set(tile_set:TileSet, image:Texture) -> TileSet:
	tile_set = tile_set.duplicate()
	tile_set.tile_set_texture(0, image)
	return tile_set
