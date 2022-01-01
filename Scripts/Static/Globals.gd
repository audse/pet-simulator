extends Node

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var random:RandomNumberGenerator = RandomNumberGenerator.new()

static func get_children_in_group(node:Node, group:String) -> Array:
	var children:Array = []
	for child in node.get_children():
		if child.is_in_group(group):
			children.append(child)
		
		# Recursively search children
		children += get_children_in_group(child, group)
	return children

func disable_camera_drag() -> void:
	var camera = get_tree().current_scene.get_node_or_null("Camera")
	if camera:
		camera.dragging_disabled = true

func enable_camera_drag() -> void:
	var camera = get_tree().current_scene.get_node_or_null("Camera")
	if camera:
		camera.dragging_disabled = false

static func is_within_control(point:Vector2, node:Control) -> bool:
	var node_rect:Rect2 = Rect2(node.rect_global_position, node.rect_size)
	return node_rect.has_point(point)
