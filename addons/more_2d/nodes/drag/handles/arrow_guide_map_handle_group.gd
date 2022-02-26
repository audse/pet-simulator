class_name ArrowGuideMapHandleGroup extends GuideMapHandleGroup

onready var button_frames:Dictionary = {
	vertical = preload("res://Assets/Interface/Buttons/Pixel/tres/arrows_vertical_button_sprite_frames.tres"),
	horizontal = preload("res://Assets/Interface/Buttons/Pixel/tres/arrows_horizontal_button_sprite_frames.tres")
}

var arrows:Dictionary = {
	right = null,
	left = null,
	down = null,
	up = null
}

export(Color) var arrow_modulate_color:Color = Color("#78848d")


func _init(
	base_map_value:TileMap=base_map, 
	is_autotile_value:bool=true
).(base_map_value, is_autotile_value) -> void:
	pass


func adjust_positions(animate:bool=true) -> void:
	for arrow in arrows.values():
		if animate:
			arrow.tween_to_position(arrow.get_target_position())
		else:
			arrow.global_position = arrow.get_target_position()


func draw() -> void:
	arrows.down = ArrowGuideMapHandle.new(
		Globals.Direction.DOWN,
		base_map,
		{
			frames = button_frames.vertical,
			start_modulate = arrow_modulate_color
		}
	)
	arrows.up = ArrowGuideMapHandle.new(
		Globals.Direction.UP,
		base_map,
		{
			frames = button_frames.vertical,
			start_frame = 3,
			start_modulate = arrow_modulate_color
		}
	)
	arrows.left = ArrowGuideMapHandle.new(
		Globals.Direction.LEFT,
		base_map,
		{
			frames = button_frames.horizontal,
			start_modulate = arrow_modulate_color
		}
	)
	arrows.right = ArrowGuideMapHandle.new(
		Globals.Direction.RIGHT,
		base_map,
		{
			frames = button_frames.horizontal,
			start_frame = 5,
			start_modulate = arrow_modulate_color
		}
	)
	
	for arrow in arrows.values():
		add_child(arrow)
		connect_signals(arrow)
		if arrow != arrows.right:
			arrow.enter()
		else:
			yield(arrow.enter(), "completed")
	yield(get_tree(), "idle_frame")


func connect_signals(arrow:ArrowGuideMapHandle) -> void:
	_connect = arrow.connect("handle_drag_started", self, "handle_drag_started")
	_connect = arrow.connect("handle_drag_released", self, "handle_drag_released")
	_connect = arrow.connect("add_guide_cells_to_direction", self, "add_guide_cells_to_direction")


func add_guide_cells_to_direction(
	num_additions:int, 
	handle:ArrowGuideMapHandle
) -> void:
	if ( 
		latest_addition.num_additions != num_additions 
		or latest_addition.direction != handle.direction
	):
		guide.tile_map.clear()
		var cells_to_set:Array = base_map.add_to_direction(handle.direction, num_additions)
		var is_erasing_real_cells = num_additions < 0
		
		if not is_erasing_real_cells:
			guide.container.modulate = guide_map_modulate_colors.positive
		else:
			guide.container.modulate = guide_map_modulate_colors.negative
		
		for cell in cells_to_set:
			if not is_erasing_real_cells:
				guide.tile_map.set_cellv(cell.to, 0)
			else:
				guide.tile_map.set_cellv(cell.from, 0)
				
		latest_addition.num_additions = num_additions
		latest_addition.direction = handle.direction


func update_positions() -> void:
	for arrow in arrows.values():
		arrow.update_position()
