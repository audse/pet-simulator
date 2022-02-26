class_name ArrowGuideMapHandle
extends GuideMapHandle
 
signal add_guide_cells_to_direction(num_additions, node)

var direction:int

func _init(
		direction_value:int, 
		map_value:TileMap, 
		args:Dictionary
).(map_value, args) -> void:
	direction = direction_value
	
#	match direction:
#		Globals.Direction.DOWN, Globals.Direction.UP:
#			drag_args.snap_axis = Globals.Axis.VERTICAL
#		Globals.Direction.LEFT, Globals.Direction.RIGHT:
#			drag_args.snap_axis = Globals.Axis.HORIZONTAL


func _enter_tree() -> void:
	global_position = get_target_position() + sprite_offset


func _input(_event:InputEvent) -> void:
	if is_updating:
		emit_signal("add_guide_cells_to_direction", get_num_cells_passed(), self)


func get_target_position() -> Vector2:
	if base_map:
#		var sprite_offset:Vector2 = get_texture_size() / 2

		var rect:Vector2 = base_map.get_used_rect().size
		var map_offset:Vector2 = Vector2.ZERO
		
		match direction:
			Globals.Direction.DOWN:
				map_offset.y = rect.y
				rotation_degrees = 60
			
			Globals.Direction.UP:
				map_offset.y = -rect.y
				rotation_degrees = 60
			
			Globals.Direction.LEFT:
				map_offset.x = -rect.x
				rotation_degrees = 30
			
			Globals.Direction.RIGHT:
				map_offset.x = rect.x
				rotation_degrees = 30
		
		var target_position:Vector2 = base_map.get_midpoint_cell() + map_offset
		
		return -Iso.map_to_iso(base_map, target_position)
	return Vector2.ZERO


func update_position() -> void:
	var target_position:Vector2 = get_target_position()
	tween_to_position(target_position)


func enter() -> void:
	self_modulate.a = 0
	scale = Vector2(0, 0)
	Tweens.tween(self, "self_modulate:a", 0, 1, 0.5)
	yield(Tweens.tween(self, "scale", Vector2(0, 0), Vector2(1.1, 1.1), 0.25), "completed")
	yield(Tweens.tween(self, "scale", Vector2(1.1, 1.1), Vector2(1, 1), 0.25), "completed")


func get_num_cells_passed(start_coord:Vector2=from_coord, end_coord:Vector2=to_coord) -> int:
	
	var delta:Vector2 = start_coord - end_coord
	var num_cells_passed:int = 0
	
	match direction:
		Globals.Direction.DOWN, Globals.Direction.UP:
			num_cells_passed = int(abs(delta.y))
			continue
		Globals.Direction.RIGHT, Globals.Direction.LEFT:
			num_cells_passed = int(abs(delta.x))
			continue
		Globals.Direction.DOWN:
			if end_coord.y < start_coord.y:
				num_cells_passed *= -1
		Globals.Direction.UP:
			if end_coord.y > start_coord.y:
				num_cells_passed *= -1
		Globals.Direction.RIGHT:
			if end_coord.x < start_coord.x:
				num_cells_passed *= -1
		Globals.Direction.LEFT:
			if end_coord.x > start_coord.x:
				num_cells_passed *= -1
		
	return num_cells_passed
