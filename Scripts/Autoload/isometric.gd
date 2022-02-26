class_name Iso
extends Object

""" Iso
A set of helper functions for mapping to and from isometric coordinates

	The axis are like this:

 		-2X            -2Y
	 		-1X    -1Y
		 		0XY
	  		1Y      1X
  		2Y              2X

	- the x value is inverted from cartesian coordinates
	- the y value is the same as cartesian
"""

static func map_to_iso(map:TileMap, map_position:Vector2, to_center:bool=false) -> Vector2:
	""" map_to_iso
		Find the corresponding isometric position to tilemap coords
	
		:param map: TileMap
			the base map to plot coordinates to
		:param map_position: Vector2
			cartesian map coordinates to be transformed (in cells, not pixels)
		:param to_center: bool, defaults to false
			if true, adjusts returned position to fall in center of tile
		
		:returns: Vector2
			isometric map position
	"""
	var iso_position := to_iso(Vector2(
		map.cell_size.y * map_position.x,
		map.cell_size.y * map_position.y
	))
	if to_center: iso_position.y += (map.cell_size.y / 2.0)
	return iso_position


static func to_iso(position:Vector2, x_fix:int=-1) -> Vector2:
	""" to_iso
	
		:param position: Vector2
			cartesian coordinates to be transformed
		:param x_fix: int, defaults to -1
			Godot has the isometric x axis backwards, so this flips it.
			May not be needed all the time, so it's optional
	"""
	return Vector2(
		(x_fix * position.x) + position.y,
		((x_fix * position.x) - position.y) / 2.0
	)


static func from_iso(iso_position:Vector2, x_fix:int=-1) -> Vector2:
	""" from_iso
	
		:param position: Vector2
			isometric coordinates to be transformed
		:param x_fix: int, defaults to -1
			Godot has the isometric x axis backwards, so this flips it.
			May not be needed all the time, so it's optional
	"""
	return Vector2(
		((x_fix * iso_position.x) - iso_position.y) / 1.5,
		(x_fix * iso_position.x) / 3.0 + iso_position.y / 1.5
	)


static func snap_to_iso_axis(delta:Vector2, axis:int) -> Vector2:
	""" snap_to_iso
	
		:param delta: Vector2
		:param axis: int, one of Globals.AXIS
	"""
	match axis:
		Globals.Axis.HORIZONTAL:
			delta.y = 0
		Globals.Axis.VERTICAL:
			delta.x = 0
	
	return to_iso(delta)
