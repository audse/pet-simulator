class_name ScrollGrid
extends MarginContainer

export (int) var rows:int = 2
export (int) var columns:int = 4
export (float) var speed:float = 1.5
export (int) var peek_amount:int = 12

var prev_mouse_position:Vector2 = Vector2.ZERO
var stop_at:Dictionary = {
	left = 0.0,
	right = 0.0,
}

var target_position_increment:float = 0
var target_position:float = 0

onready var Grid = $GridControl/Grid
onready var DragNode = $GridControl/Drag


func _init() -> void:
	setup()


func setup() -> void:
	set_rect_width_from_num_items()
	disable_buttons_from_num_items()
	
	# Wait for size changes to update
	yield(get_tree(), "idle_frame")
	
	# Adjust container height to match grid height
	rect_size.y = Grid.rect_size.x
	
	# Adjust drag node dimensions
	DragNode.TouchAreaShape = Grid.get_rect()
	DragNode.snap_axis = Globals.Axis.HORIZONTAL
	
	stop_at = get_stop_position()
	

func _process(_delta:float) -> void:
	if DragNode.is_dragging and is_zero_approx(target_position):
		if prev_mouse_position != Vector2.ZERO:
			var delta:Vector2 = get_parent().make_canvas_position_local(get_viewport().get_mouse_position()) - prev_mouse_position
#			var delta:Vector2 = get_global_mouse_position() - prev_mouse_position
			delta *= speed
				
			var new_position:float = Grid.rect_position.x + delta.x
			
			if is_valid_position(new_position):
				Grid.rect_position.x += delta.x
				DragNode.position.x += delta.x
			else:
				snap_to_stop_position(new_position)
			
		prev_mouse_position = get_parent().make_canvas_position_local(get_viewport().get_mouse_position())
	
	elif not abs(target_position) < 5:
		var delta:float = (target_position / abs(target_position)) * (speed * 5)
		var new_position:float = Grid.rect_position.x + delta
		
		if is_valid_position(new_position):
			Grid.rect_position.x += delta
			DragNode.position.x += delta
			target_position -= delta
		else:
			target_position = 0
			snap_to_stop_position(new_position)
	else:
		target_position = 0


func set_rect_width_from_num_items() -> void:
	var num_items:int = Grid.get_child_count()
	
	if rows > 0 and columns > 0:
		# warning-ignore:narrowing_conversion
		var num_sets:int = ceil(float(num_items) / float(rows * columns))
		var total_columns:int = columns * num_sets
		
		var grid_width:float = ((rect_size.x - peek_amount) / columns) * total_columns
		
		Grid.rows = rows
		Grid.set_min_width(grid_width)
		Grid.set_width(grid_width)
		Grid.rect_position.x = Grid.rect_position.x + (peek_amount / 4)
		
		if total_columns > 0:
			target_position_increment = (grid_width / total_columns) + (peek_amount / total_columns)


func disable_buttons_from_num_items() -> void:
	var num_items:int = Grid.get_child_count()
	var num_items_per_set:int = rows * columns
	
	if num_items <= num_items_per_set:
		$LeftPanel.modulate.a = 0.6
		$RightPanel.modulate.a = 0.6


func get_stop_position() -> Dictionary:
	var screen:Rect2 = get_global_rect()
	var x_pos:float = Grid.rect_position.x
	var width:float = Grid.get_size().x
	return {
		left = x_pos + peek_amount,
		right = (x_pos - width + screen.size.x) - (peek_amount * 2)
	}


func get_distance_to_stop(new_position:float) -> Dictionary:
	return {
		left = abs(new_position - stop_at.left),
		right = abs(new_position - stop_at.right)
	}


func is_valid_position(new_position:float) -> bool:
	return (
			new_position < stop_at.left 
			and new_position > stop_at.right
	)


func snap_to_stop_position(new_position:float) -> void:
	var distance_to_stop:Dictionary = get_distance_to_stop(new_position)
	
	if distance_to_stop.left < distance_to_stop.right:
		Grid.rect_position.x = stop_at.left
		DragNode.position.x = stop_at.left
	else:
		Grid.rect_position.x = stop_at.right
		DragNode.position.x = stop_at.right


func _on_drag_released(_from_pos, _to_pos):
	prev_mouse_position = Vector2.ZERO


func _on_LeftButton_pressed():
	target_position = target_position_increment


func _on_RightButton_pressed():
	target_position = -target_position_increment
