extends Node2D

func _ready() -> void:
	yield(Timers.wait(1), "completed")
	
	var cells:Array = [
		{
			from = Vector2(7, 1),
			to = Vector2(8, 1),
		},
		{
			from = Vector2(7, 0),
			to = Vector2(8, 0),
		},
	]
	
#	$TileMap.slide_set_cells(cells)
