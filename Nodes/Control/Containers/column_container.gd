tool
class_name ColumnContainer
extends Container

export (int) var rows:int = 2
export (int) var visible_columns:float = -1.0
export (Vector2) var separation:Vector2 = Vector2(10.0, 10.0)
export (bool) var is_square:bool = false # matches height to width
export (bool) var keep_aspect:bool = false # matches height to width
export (Vector2) var aspect_ratio:Vector2 = Vector2.ONE

var full_rect_size:Vector2


func _notification(what:int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			organize_children()


func organize_children() -> void:
	var size:Vector2 = get_child_size()
	
	var index:int = 0
	for child in get_children():
		
		if child is Control:
			var coords:Vector2 = get_child_coords(index)
			var position:Vector2 = (
					(coords * size)
					+ (coords * Vector2(
							separation.x,
							separation.y
					))
			)
			fit_child_in_rect(
				child,
				Rect2(position, size)
			)
		index += 1
	
	full_rect_size = get_full_rect_size()
	
	if is_square:
		# adjust container size to fit children
		rect_size.y = full_rect_size.y


func get_full_rect_size() -> Vector2:
	var num_children:float = float(get_child_count())
	var num_columns:float = ceil(num_children / float(rows))
	var child_size:Vector2 = get_child_size()
	return Vector2(
		(num_columns * child_size.x) + ((num_columns + 1) * separation.x),
		(rows * child_size.y) + ((rows + 1) * separation.y)
	)
	

func get_child_size() -> Vector2:
	var num_children:float = float(get_child_count())
	var num_columns:float = ceil(num_children / float(rows))
	var size:Vector2 = Vector2.ZERO
	
	if is_equal_approx(visible_columns, -1.0):
		# All columns should be within container bounds
		size.x = ((rect_size.x + separation.x) / num_columns) - separation.x
		
	else:
		# Columns may overflow, such as in scrolling grid		
		size.x = ((rect_size.x + separation.x)  / float(visible_columns)) - separation.x
	
	size.y = ((rect_size.y + separation.y) / float(rows)) - separation.y
	
	if is_square:
		size.y = size.x
	
	if keep_aspect:
		if aspect_ratio == Vector2.ONE:
			size.y = size.x
		
		elif aspect_ratio.x == 1:
			size.y = size.x * aspect_ratio.y
			
		elif aspect_ratio.y == 1:
			size.x = size.y * aspect_ratio.x
	
	return size


""" get_child_coords
Returns coords in [column, row] format

Ex. rows=3, columns=3
[0, 0] [1, 0] [2, 0]
[0, 1] [1, 1] [2, 1]
[0, 2] [1, 2] [2, 2]
"""
func get_child_coords(index:int) -> Vector2:
	
	var column:float = ceil(float(index + 1) / float(rows)) - 1
	var row:int = index % rows
	
	return Vector2(column, row)
