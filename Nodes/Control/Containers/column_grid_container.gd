class_name ColumnGridContainer
extends GridContainer

export (int) var rows:int = 2

var original_dimensions:Vector2


func _ready() -> void:
	original_dimensions = rect_size
	setup()


func setup() -> void:
	yield(get_tree(), "idle_frame")
	_rotate()
	_adjust_columns()
	set_height(_get_tallest_column_height())

	yield(get_tree(), "idle_frame")
	_rotate_children()


func get_rect() -> Rect2:
	return Rect2(
		rect_position,
		get_size()
	)


func get_size() -> Vector2:
	return Vector2(
		rect_size.y,
		rect_size.x
	)


func set_width(width:float) -> void:
	rect_size.y = width


func set_height(height:float) -> void:
	rect_size.x = height


func set_min_width(width:float) -> void:
	rect_min_size.y = width


func set_min_height(height:float) -> void:
	rect_min_size.x = height


func fit_child(child:Control) -> void:
	child.rect_rotation += 90
	child.rect_scale.y *= -1
	child.rect_size = Vector2(
			child.rect_size.y,
			child.rect_size.x
	)


func _rotate() -> void:
	rect_rotation = 90
	rect_scale.y = -1


func _rotate_children() -> void:
	for child in get_children():
		if child is Control:
			fit_child(child)


func _adjust_columns() -> void:
	columns = rows


func _get_tallest_column_height() -> float:
	var children:Array = get_children()
	var children_in_columns:Array = []
	
	while len(children) > 0:
		var column_children:Array = children.slice(0, rows - 1, 1, true)
		for i in range(rows):
			children.pop_front()
		children_in_columns.append(column_children)
	
	var tallest_column_height:float = 0.0
	for column in children_in_columns:
		var column_height:float = 0.0
		for node in column:
			if node is Control:
				column_height += node.rect_size.x
		if column_height > tallest_column_height:
			tallest_column_height = column_height
	
	return tallest_column_height
	
#	for child in children:
#
#		if current_row == 0:
#
#
#		current_row += 1
#		if current_row == rows:
#			current_row = 0
