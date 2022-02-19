extends ViewportContainer

onready var ViewportNode:Viewport = $MainViewport
onready var parent_viewport:Viewport = get_viewport()

#func _process(_delta: float) -> void:
#	rect_global_position = get_viewport_transform().affine_inverse().origin
#	ViewportNode.canvas_transform = parent_viewport.canvas_transform
