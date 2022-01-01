extends Node2D

class_name Drag

var camera_disabled:bool = false # disabled by camera so that original disable status is not altered
export var disabled:bool = false
export(Rect2) var TouchAreaShape = Rect2(-12, -12, 24, 24)

signal drag_released(from_pos, to_pos)
signal drag_started()
signal dragging(drag_delta)

var from_pos:Vector2
var is_dragging:bool = false

func _unhandled_input(event:InputEvent) -> void:
	
	if event is InputEventScreenDrag and not disabled:
		
		if TouchAreaShape.has_point(to_local(get_global_mouse_position())):
			if not is_dragging:
				is_dragging = true
				from_pos = get_global_mouse_position()
				emit_signal("drag_started")
			
			emit_signal("dragging", event.relative)
		
	if event.is_action_released("ui_touch"):
		
		if is_dragging:
			is_dragging = false
			emit_signal("drag_released", from_pos, get_global_mouse_position())
