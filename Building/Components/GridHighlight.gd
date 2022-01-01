extends AnimatedSprite

var map:TileMap
var disabled:bool = true
var sprite_offset:Vector2 = Vector2(12, 12)

func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed() and not event.is_echo():
		if not disabled and map:
			var coordinates = map.world_to_map(get_global_mouse_position())
			position = map.map_to_world(coordinates) + sprite_offset

func start(current_map:TileMap) -> void:
	disabled = false
	modulate.a = 0
	visible = true
	playing = true
	Tweens.tween(self, "modulate:a", 0, 1, 0.25)
	map = current_map
	if map:
		position = get_center_tile_position()
	
func stop() -> void:
	yield(Tweens.tween(self, "modulate:a", 1, 0, 0.25), "completed")
	playing = false
	visible = false
	disabled = true

func get_center_tile_coordinates() -> Vector2:
	var screen_center:Vector2 = get_viewport_rect().size / 2 
	screen_center -= get_parent().get_global_transform_with_canvas().origin
	return map.world_to_map(screen_center)
	
func get_center_tile_position() -> Vector2:
	var coordinates = get_center_tile_coordinates()
	return map.map_to_world(coordinates) - sprite_offset
