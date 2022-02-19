tool
class_name VariableTextureTileMap
extends AnimatedAutotile

export (int) var tile_index:int = 0
export (Texture) var texture:Texture setget set_tileset_texture, get_tileset_texture


func set_tileset_texture(new_texture:Texture) -> void:
	tile_set.tile_set_texture(tile_index, new_texture)


func get_tileset_texture() -> Texture:
	return tile_set.tile_get_texture(tile_index)

