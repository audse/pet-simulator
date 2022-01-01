extends TileMap

func set_tileset(new_tileset:TileSet) -> void:
	self.tileset = new_tileset
	$OverlayTileMap.tileset = new_tileset

func set_cell_size(new_cell_size:Vector2) -> void:
	self.cell_size = new_cell_size
	$OverlayTileMap.cell_size = new_cell_size

func animate(from_cell:Array, to_cell:Array, tile:int) -> void:
	$OverlayTileMap.set_cell(from_cell[0], from_cell[1], tile)
	
	$OverlayTileMap.global_position = self.global_position
	var end_position:Vector2 = Vector2(
		(to_cell[0] - from_cell[0]) * self.cell_size.x,
		(to_cell[1] - from_cell[1]) * self.cell_size.y
	)
	
	yield(Tweens.move(
			$OverlayTileMap,
			end_position,
			0.2,
			Tween.TRANS_CUBIC,
			Tween.EASE_IN_OUT
		), "completed")
		
	self.set_cell(to_cell[0], to_cell[1], tile)
	$OverlayTileMap.clear()
