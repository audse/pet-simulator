class_name FollowViewportChild
extends Node

""" FollowViewportChild

A helper node that takes a target node and transforms it's position to attach 
to a node within a viewport. Useful when dealing with viewports with different 
shrink sizes and cameras within viewports.

Attributes:
	target_node (Node2D or Control): 
		the node that will be transformed
	parent_node (Node2D or Control): 
		the node that will be used as reference when calculating 
		transformations
	viewport (Viewport):
		the viewport should be a parent of the parent_node (either direct or
		indirect)
	viewport_camera (Camera2D): 
		necessary when dealing with a camera inside a viewport that has a 
		shrink value
	offset (Vector2):
		the pixel offset of the target node from the parent's position
"""

## @target_node_path: the node that will be transformed
export (NodePath) var target_node_path setget set_target_node_path, get_target_node_path
## @parent_node_path: the node that will be used as reference when calculating 
## transformations
export (NodePath) var parent_node_path setget set_parent_node_path, get_parent_node_path
## @viewport_path: the viewport should be a parent of the parent_node (either
## direct or indirect)
export (NodePath) var viewport_path setget set_viewport_path, get_viewport_path
## @viewport_camera_path: necessary when dealing with a camera inside a 
## viewport that has a shrink value
export (NodePath) var viewport_camera_path setget set_viewport_camera_path, get_viewport_camera_path
## @offset: the pixel offset of the target node from the parent's position
export (Vector2) var offset
## @is_parented: determines whether the transformations will be applied
export (bool) var is_parented = true

var target_node:Node
var parent_node:Node
var viewport:Viewport
var viewport_camera:Camera2D
var viewport_container:ViewportContainer

func _init(
		target_node_value:Node=target_node,
		parent_node_value:Node=parent_node,
		viewport_value:Viewport=viewport,
		viewport_camera_value:Camera2D=viewport_camera,
		offset_value:Vector2=Vector2.ZERO
) -> void:
	"""
	If this class is created in script, it's easier to pass
	the node values as constructor arguments than individually
	setting them. However, they're all optional.
	"""
	target_node = target_node_value
	parent_node = parent_node_value
	viewport = viewport_value
	viewport_camera = viewport_camera_value
	offset = offset_value


func _ready() -> void:
	"""
	If this node was not created in script, but in scene tree,
	the values must be set from node paths
	"""
	# if nodes were not provided on initialization (e.g. added in scene tree)
	# get them from node paths
	if not target_node and target_node_path:
		target_node = get_node_or_null(target_node_path)
	if not parent_node and parent_node_path:
		parent_node = get_node_or_null(parent_node_path)
	if not viewport and viewport_path:
		viewport = get_node_or_null(viewport_path)
	if not viewport_camera and viewport_camera_path:
		viewport_camera = get_node_or_null(viewport_camera_path)
	
	# viewport_container should always be the parent of the viewport
	if NodeRef.is_node_valid(viewport, Viewport):
		viewport_container = viewport.get_parent()
		

func _process(_delta:float) -> void:
	if is_parented:
		# set position of relative to viewport every frame
		NodeRef.set_node_position(
			target_node, 
			ViewportRef.to_viewport_position(
				offset + NodeRef.get_node_position(parent_node),
				viewport,
				viewport_camera,
				viewport_container
			)
		)


""" Setters/getters """

func set_target_node_path(node_path:NodePath) -> void:
	target_node_path = node_path
	target_node = get_node_or_null(node_path)


func get_target_node_path() -> NodePath:
	return target_node_path


func set_parent_node_path(node_path:NodePath) -> void:
	parent_node_path = node_path
	parent_node = get_node_or_null(node_path)


func get_parent_node_path() -> NodePath:
	return parent_node_path


func set_viewport_path(node_path:NodePath) -> void:
	viewport_path = node_path
	viewport = get_node_or_null(node_path)
	if NodeRef.is_node_valid(viewport, Viewport):
		viewport_container = viewport.get_parent()


func get_viewport_path() -> NodePath:
	return viewport_path


func set_viewport_camera_path(node_path:NodePath) -> void:
	viewport_camera_path = node_path
	viewport_camera = get_node_or_null(node_path)


func get_viewport_camera_path() -> NodePath:
	return viewport_camera_path
	
