extends Node2D

onready var autotiler := $Autotiler

func _ready() -> void:
	autotiler.connect("tile_set_texture_created", self, "_on_tile_set_texture_created")
	autotiler.create_layered_tile_set_texture([
		preload("res://Assets/Tiles/Design/Interior/paint/png/simple_trim_paint_reduced.png"),
		preload("res://Assets/Tiles/Design/Exterior/png/plaster_running_brick_reduced.png")
	])
	
#	texture_generator.get_texture()
	

func _on_tile_set_texture_created(tile_set_texture:Texture) -> void:
	$Sprite.texture = tile_set_texture


func _on_layered_texture_generated(layered_texture:Texture) -> void:
	autotiler.create_tile_set_texture(layered_texture)
	pass
