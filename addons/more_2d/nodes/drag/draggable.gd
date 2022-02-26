class_name Draggable
extends Drag

export (NodePath) var target_node_path = "../"

var target_node:Node2D

var prev_mouse_position:Vector2 = Vector2.ZERO


func _init(target_node_value:Node2D=null, args:Dictionary={}).(args) -> void:
	target_node = target_node_value


func _enter_tree() -> void:
	if not target_node and target_node_path:
		target_node = get_node_or_null(target_node_path)


func _ready() -> void:
	print(TouchAreaShape)


func _input(event:InputEvent) -> void:
	if not unhandled_only:
		_unhandled_input(event)


func _unhandled_input(event:InputEvent) -> void:
	if is_dragging and target_node:
		if prev_mouse_position != Vector2.ZERO:
			var delta:Vector2 = event.position - prev_mouse_position

			match snap_axis:
				Globals.Axis.HORIZONTAL:
					delta.y = 0
				Globals.Axis.VERTICAL:
					delta.x = 0

			if not allow_camera_scroll and is_at_camera_edge:
				delta = Vector2.ZERO
			
			target_node.global_position += delta
			
		prev_mouse_position = event.position
	else:
		prev_mouse_position = Vector2.ZERO
