extends Node2D

class_name Construct

enum {
	TOP_LEFT,
	TOP,
	TOP_RIGHT,
	LEFT,
	CENTER,
	RIGHT,
	BOTTOM_LEFT,
	BOTTOM,
	BOTTOM_RIGHT
}

var start_cell_x:int = 4
var start_cell_y:int = 4

var layout:Array = [
	[TOP_LEFT, TOP, TOP_RIGHT],
	[LEFT, CENTER, RIGHT],
	[BOTTOM_LEFT, BOTTOM, BOTTOM_RIGHT],
]

onready var Arrow:Dictionary = {
	"Right": $Arrows/ArrowRight,
	"Left": $Arrows/ArrowLeft,
	"Up": $Arrows/ArrowUp,
	"Down": $Arrows/ArrowDown,
	"Group": {
		"All": Globals.get_children_in_group(self, "arrows"),
		"Horizontal": Globals.get_children_in_group(self, "arrow_horizontal"),
		"Vertical": Globals.get_children_in_group(self, "arrow_vertical"),
		"Reverse": Globals.get_children_in_group(self, "arrow_reverse"),
		"Back": {
			"All": Globals.get_children_in_group(self, "arrow_back"),
			"Horizontal":  Globals.get_children_in_group(self, "arrow_back_horizontal"),
			"Vertical": Globals.get_children_in_group(self, "arrow_back_vertical"),
		}
	}
}

func _ready() -> void:
	pass

func start(x:int, y:int) -> void:
	for arrow in Arrow.Group.All:
		arrow.visible = true
	start_cell_x = x - 1
	start_cell_y = y - 1
	draw_layout()
	update_arrow_positions(false)
	
func stop() -> void:
	for arrow in Arrow.Group.All:
		arrow.visible = false

func get_used_tiles() -> Array:
	var used_tiles:Array = []
	
	var row_index:int = 0
	for row in layout:
		var cell_index:int = 0
		for cell in row:
			used_tiles.append({
				x = cell_index + start_cell_x,
				y = row_index + start_cell_y,
				tile = cell
			})
			cell_index += 1
		row_index += 1
	return used_tiles

# `animate_in` is a 2D array of indices for the cells that should be animated
# e.g. [[0, 0], [1, 0]] will animate the top left and adjaecent tile
func draw_layout(animate:Array=[], add_to:int=Globals.Direction.LEFT) -> void:
	$AnimatedTileMap.clear()
	var row_index:int = 0
	for row in layout:
		var cell_index:int = 0
		for cell in row:
			if [row_index, cell_index] in animate:
				var start_cell:Array = [start_cell_x + cell_index, start_cell_y + row_index]
				match add_to:
					Globals.Direction.LEFT:
						start_cell[0] += 1
					Globals.Direction.RIGHT:
						start_cell[0] -= 1
					Globals.Direction.UP:
						start_cell[1] += 1
					Globals.Direction.DOWN:
						start_cell[1] -= 1
						
				$AnimatedTileMap.animate(
					start_cell,
					[start_cell_x + cell_index, start_cell_y + row_index],
					cell
				)
			else:
				$AnimatedTileMap.set_cell(
					start_cell_x + cell_index,
					start_cell_y + row_index,
					cell
				)
			cell_index += 1
		row_index += 1

static func add_row(cell_layout:Array) -> Array:
	var bottom_row:Array = cell_layout.pop_back()
	var new_row:Array = [LEFT]
	
	var cell_index:int = 0
	for cell in bottom_row:
		if cell_index != 0 and cell_index != len(bottom_row) - 1:
			new_row.append(CENTER)
		cell_index += 1
		
	new_row.append(RIGHT)
	
	cell_layout.append(new_row)
	cell_layout.append(bottom_row)
	
	return cell_layout

static func remove_row(cell_layout:Array) -> Array:
	var bottom_row:Array = cell_layout.pop_back()
	cell_layout.pop_back()
	cell_layout.append(bottom_row)
	return cell_layout

static func add_column(cell_layout:Array) -> Array:
	var row_index:int = 0
	for row in cell_layout:
		var last_cell:int = row.pop_back()
		
		if row_index == 0:
			row.append(TOP)
		elif row_index == len(cell_layout) - 1:
			row.append(BOTTOM)
		else:
			row.append(CENTER)
		
		row.append(last_cell)
		row_index += 1
		
	return cell_layout

static func remove_column(cell_layout:Array) -> Array:
	for row in cell_layout:
		var last_cell:int = row.pop_back()
		row.pop_back()
		row.append(last_cell)
	return cell_layout

static func get_column_indices(cell_layout:Array, reverse:bool=false) -> Array:
	var num_rows:int = len(cell_layout)
	var num_columns:int = len(cell_layout[0])
	
	var column_index:int = (
		num_columns - 1
		if not reverse
		else 0
	)
	var indices:Array = []
	for row_index in range(0, num_rows):
		indices.append([row_index, column_index])
	
	return indices
	
static func get_row_indices(cell_layout:Array, reverse:bool=false) -> Array:
	var num_rows:int = len(cell_layout)
	var num_columns:int = len(cell_layout[0])
	
	var row_index:int = (
		num_rows - 1
		if not reverse
		else 0
	)
	var indices:Array = []
	for column_index in range(0, num_columns):
		indices.append([row_index, column_index])
	
	return indices

func update_arrow_disabled() -> void:
	var num_rows:int = len(layout)
	var num_columns:int = len(layout[0])
	for arrow in Arrow.Group.Back.All:
		arrow.disabled = false
		arrow.modulate.a = 0.5
		
	if num_rows <= 3:
		for arrow in Arrow.Group.Back.Vertical:
			arrow.disabled = true
			arrow.modulate.a = 0
	if num_columns <= 3:
		for arrow in Arrow.Group.Back.Horizontal:
			arrow.disabled = true
			arrow.modulate.a = 0

func update_arrow_positions(animate:bool=true) -> void:
	update_arrow_disabled()
	var arrow_positions:Dictionary = get_arrow_posititons(layout)
	var time = 0.15
	if animate:
		Tweens.tween(
			Arrow.Right,
			"rect_position",
			Arrow.Right.rect_position,
			arrow_positions.right,
			time
		)
		Tweens.tween(
			Arrow.Down,
			"rect_position",
			Arrow.Down.rect_position,
			arrow_positions.down,
			time
		)
		Tweens.tween(
			Arrow.Left,
			"rect_position",
			Arrow.Left.rect_position,
			arrow_positions.left,
			time
		)
		Tweens.tween(
			Arrow.Up,
			"rect_position",
			Arrow.Up.rect_position,
			arrow_positions.up,
			time
		)
	else:
		Arrow.Right.rect_position = arrow_positions.right
		Arrow.Left.rect_position = arrow_positions.left
		Arrow.Up.rect_position = arrow_positions.up
		Arrow.Down.rect_position = arrow_positions.down
	
func get_arrow_posititons(cell_layout:Array) -> Dictionary:
	var top_left:Vector2 = Vector2(24 * start_cell_x, 24 * start_cell_y)
	var dimensions:Vector2 = Vector2(24 * len(cell_layout[0]), 24 * len(cell_layout))
	var midpoints:Vector2 = Vector2(dimensions.x / 2 - 12, dimensions.y / 2 - 12)
	
	var positions:Dictionary = {
		right = top_left + Vector2(dimensions.x, midpoints.y),
		left = top_left + Vector2(-24, midpoints.y),
		up = top_left + Vector2(midpoints.x, -24),
		down = top_left + Vector2(midpoints.x,dimensions.y)
	}
	
	return positions

func draw_remove(direction:int=Globals.Direction.RIGHT):
	var reverse:bool = direction in [Globals.Direction.LEFT, Globals.Direction.UP]
	var removed:Array = get_row_indices(layout, reverse)
	var tiles:Array = [LEFT, RIGHT]
	var offset_factor:Dictionary = {x = 0, y = 0}
	
	if direction in [Globals.Direction.LEFT, Globals.Direction.RIGHT]:
		removed = get_column_indices(layout, reverse)
		tiles = [TOP, BOTTOM]
	
	match direction:
		Globals.Direction.LEFT:
			offset_factor.x = 1
		Globals.Direction.RIGHT:
			offset_factor.x = -1
		Globals.Direction.UP:
			offset_factor.y = 1
		Globals.Direction.DOWN:
			offset_factor.y = -1
	
	var cell_index:int = 0
	for cell in removed:
		var tile:int = (
			tiles[0]
			if cell_index == 0
			else tiles[1]
			if cell_index == len(removed) - 1
			else CENTER
		)
		$AnimatedTileMap.animate(
			[
				start_cell_x + cell[1] + (1 * offset_factor.x),
				start_cell_y + cell[0] + (1 * offset_factor.y)
			],
			[
				start_cell_x + cell[1] + (2 * offset_factor.x),
				start_cell_y + cell[0] + (2 * offset_factor.y)
			],
			tile
		)
		cell_index += 1

func _on_ArrowRight_pressed():
	layout = add_column(layout)
	var animate:Array = get_column_indices(layout)
	draw_layout(animate, Globals.Direction.RIGHT)
	update_arrow_positions()

func _on_ArrowRight_ArrowBack_pressed():
	draw_remove(Globals.Direction.RIGHT)
	layout = remove_column(layout)
	var animate:Array = get_column_indices(layout)
	draw_layout(animate, Globals.Direction.LEFT)
	update_arrow_positions()

func _on_ArrowDown_pressed():
	layout = add_row(layout)
	var animate:Array = get_row_indices(layout)
	draw_layout(animate, Globals.Direction.DOWN)
	update_arrow_positions()

func _on_ArrowDown_ArrowBack_pressed():
	draw_remove(Globals.Direction.DOWN)
	layout = remove_row(layout)
	var animate:Array = get_row_indices(layout)
	draw_layout(animate, Globals.Direction.UP)
	update_arrow_positions()
	
func _on_ArrowLeft_pressed():
	layout = add_column(layout)
	start_cell_x -= 1
	var animate:Array = get_column_indices(layout, true)
	draw_layout(animate, Globals.Direction.LEFT)
	update_arrow_positions()

func _on_ArrowLeft_ArrowBack_pressed():
	draw_remove(Globals.Direction.LEFT)
	layout = remove_column(layout)
	start_cell_x += 1
	var animate:Array = get_column_indices(layout, true)
	draw_layout(animate, Globals.Direction.RIGHT)
	update_arrow_positions()

func _on_ArrowUp_pressed():
	layout = add_row(layout)
	start_cell_y -= 1
	var animate:Array = get_row_indices(layout, true)
	draw_layout(animate, Globals.Direction.UP)
	update_arrow_positions()

func _on_ArrowUp_ArrowBack_pressed():
	draw_remove(Globals.Direction.UP)
	layout = remove_row(layout)
	start_cell_y += 1
	var animate:Array = get_row_indices(layout, true)
	draw_layout(animate, Globals.Direction.DOWN)
	update_arrow_positions()
	
