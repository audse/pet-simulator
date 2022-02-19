extends Node2D

class_name Drag

signal drag_released(from_pos, to_pos)
signal drag_started(from_pos)

export (bool) var unhandled_only:bool = true

var camera_disabled:bool = false # disabled by camera so that original disable status is not altered
export var disabled:bool = false
export(Rect2) var TouchAreaShape = Rect2(-12, -12, 24, 24)
export var snap_axis:int = Globals.Axis.NONE

export(bool) var allow_camera_scroll:bool = true
export(Vector2) var camera_edge_margin:Vector2 = Vector2(20, 30)
export(float) var camera_edge_extra_margin_bottom:float = 30
export(int) var camera_scroll_speed:int = 2

var from_pos:Vector2
var is_dragging:bool = false
var is_at_camera_edge:bool = false


func _init(args:Dictionary={}) -> void:
	match args:
		{"unhandled_only", ..}:
			unhandled_only = args.unhandled_only
			continue
		{"disabled", ..}:
			disabled = args.disabled
			continue
		{"touch_area_shape", ..}:
			TouchAreaShape = args.touch_area_shape
			continue
		{"snap_axis", ..}:
			snap_axis = args.snap_axis
			continue
		{"allow_camera_scroll", ..}:
			allow_camera_scroll = args.allow_camera_scroll
			continue
		{"camera_edge_margin", ..}:
			camera_edge_margin = args.camera_edge_margin
			continue
		{"camera_edge_extra_margin_bottom", ..}:
			camera_edge_extra_margin_bottom = args.camera_edge_extra_margin_bottom
			continue
		{"camera_scroll_speed", ..}:
			camera_scroll_speed = args.camera_scroll_speed
			continue


func _ready():
	if get_child_count() > 0:
		$ColorRect.rect_position = TouchAreaShape.position
		$ColorRect.rect_size = TouchAreaShape.size


func _process(_delta) -> void:
	
	if is_at_camera_edge and allow_camera_scroll:
		var delta:Vector2 = Vector2(0, 0)
		
		var mouse_position:Vector2 = get_local_mouse_position()
		var size = get_viewport_rect().size

		var is_at_edge:Dictionary = {
			left = mouse_position.x < camera_edge_margin.x,
			right = mouse_position.x > size.x - camera_edge_margin.x,
			top = mouse_position.y < camera_edge_margin.y,
			bottom = mouse_position.y > size.y - (camera_edge_margin.y + camera_edge_extra_margin_bottom)
		}

		if (
			is_at_edge.left
			or is_at_edge.right
			or is_at_edge.top
			or is_at_edge.bottom
		):

			if is_at_edge.left:
				delta.x = -camera_scroll_speed
			if is_at_edge.right:
				delta.x = camera_scroll_speed
			if is_at_edge.top:
				delta.y = -camera_scroll_speed
			if is_at_edge.bottom:
				delta.y = camera_scroll_speed

			Globals.scroll_camera(delta)


func _input(event:InputEvent) -> void:
	if not unhandled_only:
		_unhandled_input(event)


func _unhandled_input(event:InputEvent) -> void:
	var unlocal_event:InputEvent = event
	event = make_input_local(event)
	if event is InputEventScreenDrag and not disabled:	
		var current_position:Vector2 = to_global(event.position)
		
		if TouchAreaShape.has_point(to_local(current_position)):
			if not is_dragging:
				is_dragging = true
				from_pos = current_position
				emit_signal("drag_started", from_pos)
				Globals.disable_camera_drag()
			
			# Scroll camera
			if allow_camera_scroll:
				
				var viewport_position:Vector2 = unlocal_event.position
				var size = get_viewport_rect().size
#
				if (
					viewport_position.x < camera_edge_margin.x
					or viewport_position.x > size.x - camera_edge_margin.x
					or viewport_position.y < camera_edge_margin.y
					or viewport_position.y > size.y - (camera_edge_margin.y + camera_edge_extra_margin_bottom)
				):
					is_at_camera_edge = true
		
		
	if event.is_action_released("ui_touch"):
		Globals.enable_camera_drag()
		var current_position:Vector2 = to_global(event.position)
		if is_dragging:
			is_dragging = false
			is_at_camera_edge = false
			emit_signal("drag_released", from_pos, current_position)
