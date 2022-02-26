class_name ProcessViewportContainer
extends ViewportContainer

""" ProcessViewportContainer
	
	updates ViewportContainer every frame to fit parent viewport
"""

export (NodePath) var viewport_path = "Viewport"
var viewport:Viewport
var parent_viewport:Viewport


func _ready() -> void:
	# Find both parent and nested viewports
	parent_viewport = get_viewport()
	viewport = find_node(viewport_path)
	
	if _is_viewport_valid(viewport) and _is_viewport_valid(parent_viewport):
		# Set size of self and viewport to match parent
		viewport.size = parent_viewport.size
		rect_size = parent_viewport.size


func _process(_delta:float) -> void:
	# Set viewport size to parent viewport size
	if _is_viewport_valid(viewport) and _is_viewport_valid(parent_viewport):
		var viewport_transform = get_viewport_transform().affine_inverse().origin
		rect_global_position = viewport_transform
		viewport.canvas_transform = parent_viewport.canvas_transform


func _is_viewport_valid(current_viewport:Viewport) -> bool:
	return (
		current_viewport
		and is_instance_valid(current_viewport)
		and current_viewport is Viewport
		and current_viewport.is_inside_tree()
	)
