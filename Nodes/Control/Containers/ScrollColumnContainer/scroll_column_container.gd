class_name ScrollColumnContainer
extends Control

var _connect

export (bool) var hide_on_start:bool = true
export (float) var initial_offset:float = 25.0
export (float) var scroll_increment:float = 300.0

onready var nodes:Dictionary = {
	left_button = find_node("LeftButton"),
	right_button = find_node("RightButton"),
	column_container = $ColumnContainer,
	tween = $Tween,
	drag = $Drag,
	animation_player = $AnimationPlayer
}

var disabled:bool = true
var leftmost_position:float
var rightmost_position:float

var prev_mouse_position:Vector2 = Vector2.ZERO


func _ready() -> void:
	_connect = nodes.left_button.connect(
			"pressed", 
			self, 
			"left_button_pressed"
	)
	_connect = nodes.right_button.connect(
			"pressed", 
			self, 
			"right_button_pressed"
	)
	
	# Play start animation
	if hide_on_start:
		nodes.animation_player.play("RESET")
	else:
		nodes.animation_player.play("Enter")
		nodes.animation_player.advance(0.6)
	
	# Set leftmost/rightmost position
	yield(get_tree(), "idle_frame")
	leftmost_position = nodes.column_container.rect_position.x + (scroll_increment / 2.0)
	rightmost_position = (leftmost_position - nodes.column_container.full_rect_size.x) + (scroll_increment * 2.0)
	
	nodes.column_container.rect_position.x += initial_offset
	
	# Recenter column container when squared
	if nodes.column_container.is_square:
		
		# Resize scroll container (if needed)
		if not size_flags_vertical in [SIZE_FILL, SIZE_EXPAND, SIZE_EXPAND_FILL]:
			rect_min_size.y = nodes.column_container.full_rect_size.y
		
		nodes.column_container.rect_position.y = nodes.column_container.rect_position.y + (rect_min_size.y / 2) - (nodes.column_container.full_rect_size.y / 2)
	
	# Setup drag node
	_connect = connect("item_rect_changed", self, "update_touch_area")
	update_touch_area()
	nodes.drag.snap_axis = Globals.Axis.HORIZONTAL
	nodes.drag.disabled = true


func _input(event:InputEvent) -> void:
	if nodes.drag.is_dragging:
		if prev_mouse_position != Vector2.ZERO:
			var delta:Vector2 = event.position - prev_mouse_position
			var position:Vector2 = nodes.column_container.rect_position
			
			var target_position:Vector2 = Vector2(
					position.x + delta.x,
					position.y
			)
			
			var distance_to_left:float = abs(
					target_position.distance_to(
							Vector2(leftmost_position, position.y)
					)
			)
			
			var distance_to_right:float = abs(
					target_position.distance_to(
							Vector2(rightmost_position, position.y)
					)
			)
			
			if target_position.x <= leftmost_position and target_position.x >= rightmost_position:
				nodes.column_container.rect_position.x = target_position.x
			
			elif distance_to_right > distance_to_left:
				nodes.column_container.rect_position.x = leftmost_position
			
			else:
				nodes.column_container.rect_position.x = rightmost_position 
		
		prev_mouse_position = event.position
	else:
		prev_mouse_position = Vector2.ZERO


func enable() -> void:
	if is_overflowing():
		nodes.drag.disabled = false


func disable() -> void:
	nodes.drag.disabled = true


func is_overflowing() -> bool:
	return (
		nodes.column_container.get_child_count() > (nodes.column_container.rows * nodes.column_container.visible_columns)
		and nodes.column_container.visible_columns != -1
	)


func left_button_pressed() -> void:
	if is_overflowing():
		var target_position:float = nodes.column_container.rect_position.x + scroll_increment
		if target_position <= leftmost_position:
			nodes.tween.interpolate_property(
					nodes.column_container,
					"rect_position:x",
					nodes.column_container.rect_position.x,
					target_position,
					0.25,
					Tween.TRANS_CUBIC,
					Tween.EASE_IN_OUT
			)
			
			nodes.tween.start()


func right_button_pressed() -> void:
	if is_overflowing():
		var target_position:float = nodes.column_container.rect_position.x - scroll_increment
		if target_position >= rightmost_position:
			nodes.tween.interpolate_property(
					nodes.column_container,
					"rect_position:x",
					nodes.column_container.rect_position.x,
					target_position,
					0.25,
					Tween.TRANS_CUBIC,
					Tween.EASE_IN_OUT
			)
			
			nodes.tween.start()


func update_touch_area() -> void:
	nodes.drag.TouchAreaShape = Rect2(
		Vector2.ZERO,
		rect_size
	)
