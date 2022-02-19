class_name GridHighlight
extends AnimatedSprite

var map:TileMap
var disabled:bool = true
var sprite_offset:Vector2 = Vector2(12, 12)


func _ready() -> void:
	modulate.a = 0
	visible = false


func _unhandled_input(event:InputEvent) -> void:
	
	if event is InputEventScreenTouch and event.is_pressed() and not event.is_echo():
		if not disabled and map:
			var event_position:Vector2 = get_parent().make_canvas_position_local(event.position)
			var coordinates = map.world_to_map(event_position)
			position = map.map_to_world(coordinates) + sprite_offset


func start(current_map:TileMap, start_position=null) -> void:
	print("starting at ", self, current_map)
	disabled = false
	modulate.a = 0
	visible = true
	playing = true
	Tweens.tween(self, "modulate:a", 0, 1, 0.25)
	map = current_map
	if map and not start_position:
		position = get_center_tile_position()
	elif start_position:
		position = start_position


func stop() -> void:
	print("stopping...")
	yield(Tweens.tween(self, "modulate:a", 1, 0, 0.25), "completed")
	playing = false
	visible = false
	disabled = true


func get_center_tile_coordinates() -> Vector2:
	var screen_center:Vector2 = get_viewport_rect().size / 2 
	screen_center -= get_viewport_transform().affine_inverse().origin
	print(map.world_to_map(to_global(screen_center)))
	return map.world_to_map(to_global(screen_center))


func get_center_tile_position() -> Vector2:
	var coordinates = get_center_tile_coordinates()
	return map.map_to_world(coordinates) - sprite_offset
