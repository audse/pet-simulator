class_name TileSetGenerator
extends Resource

export (Vector2) var cell_size:Vector2 = Vector2(24, 24)

func _init(cell_size_value:Vector2=cell_size) -> void:
	cell_size = cell_size_value


func create_tile_set(texture:Texture, is_single_tile:bool, base_tile_set:TileSet=null) -> TileSet:
	if not is_single_tile and base_tile_set:
		return create_tile_set_from_base(texture, base_tile_set)
	else:
		return create_single_tile_set(texture)


func create_single_tile_set(texture:Texture) -> TileSet:
	var tile_set:TileSet = TileSet.new()
	tile_set.create_tile(0)
	tile_set.tile_set_texture(0, texture)
	
	# Add offset to non-square tiles
	var texture_size:Vector2 = texture.get_size()
	if texture_size.x != texture_size.y:
		var offset:Vector2 = Vector2(
			-texture_size.x + cell_size.x if texture_size.x > texture_size.y else 0.0,
			-texture_size.y + cell_size.y if texture_size.y > texture_size.x else 0.0
		)
		tile_set.tile_set_texture_offset(0, offset)
	
	return tile_set


func create_tile_set_from_base(texture:Texture, base_tile_set:TileSet) -> TileSet:
	# Duplicate the base tile set, as it already has the bitmasks made
	var tile_set:TileSet = base_tile_set.duplicate()
	tile_set.tile_set_texture(0, texture)
	return tile_set
