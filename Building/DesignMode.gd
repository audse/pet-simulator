extends Node2D

onready var Wallpaper = preload("res://Assets/Sprites/Building/Design/Wallpapers/vertical-stripe-blue.png")
onready var Flooring = preload("res://Assets/Sprites/Building/Design/Floorings/carpet-tan.png")
onready var Facade = preload("res://Assets/Sprites/Building/Design/Facades/brick-white.png")

onready var Roof = preload("res://Assets/Sprites/Building/Construct/tilemap_construct_roof.png")
onready var Shingle =  preload("res://Assets/Sprites/Building/Design/Roofs/shingle-black.png")

func _ready():
	
	$Wallpaper.tile_set = $Wallpaper.tile_set.duplicate()
	$Wallpaper.tile_set.tile_set_texture(0, Wallpaper)
	
	$Flooring.tile_set = $Flooring.tile_set.duplicate()
	$Flooring.tile_set.tile_set_texture(0, Flooring)
	
	$Facade.tile_set = $Facade.tile_set.duplicate()
	$Facade.tile_set.tile_set_texture(0, Facade)
	
	$Roof.tile_set = $Roof.tile_set.duplicate()
	$Roof.tile_set.tile_set_texture(0, Roof)
	$Roof.position.y -= 8
	
	$Roof2.tile_set = $Roof2.tile_set.duplicate()
	$Roof2.tile_set.tile_set_texture(0, Shingle)
	$Roof2.position.y -= 8
	
	for cell in $Structure.get_used_cells():
		$Wallpaper.set_cell(cell.x, cell.y, 0)
		$Flooring.set_cell(cell.x, cell.y, 0)
		$Facade.set_cell(cell.x, cell.y, 0)
		$Roof.set_cell(cell.x, cell.y, 0)
		$Roof2.set_cell(cell.x, cell.y, 0)
	
	yield(Timers.wait(0.25), "completed")
	$Wallpaper.update_bitmask_region()
	$Flooring.update_bitmask_region()
	$Facade.update_bitmask_region()
	$Roof.update_bitmask_region()
	$Roof2.update_bitmask_region()
