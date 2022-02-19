tool
class_name VariableTextureTileSet
extends TileSet

export(Texture) var texture:Texture setget set_tileset_texture, get_tileset_texture


func set_tileset_texture(new_texture:Texture) -> void:
	tile_set_texture(0, new_texture)


func get_tileset_texture() -> Texture:
	return tile_get_texture(0)
