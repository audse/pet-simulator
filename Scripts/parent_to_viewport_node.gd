class_name ParentToViewportNode
extends Node

var target_node:Node
var parent_node:Node
var offset:Vector2
var viewport:Viewport

var viewport_container
var camera

func _init(
		target_node_value:Node,
		parent_node_value:Node,
		viewport_value:Viewport,
		offset_value:Vector2=Vector2.ZERO
) -> void:
	target_node = target_node_value
	parent_node = parent_node_value
	offset = offset_value
	viewport = viewport_value
	
	if viewport is Viewport:
		camera = viewport.find_node("Camera")
		viewport_container = viewport.get_parent()


func _ready() -> void:
	pass

func _process(_delta:float) -> void:
	if camera is Camera2D and viewport_container is ViewportContainer:
		var stretch:int = viewport_container.stretch_shrink
		
		var target_position:Vector2 = offset
		
		# get position of parent
		if parent_node is Control:
			target_position = parent_node.rect_position
		
		elif parent_node is Node2D:
			target_position = parent_node.position
		
		# transform position by camera and viewport
		target_position -= (camera.get_camera_position() * stretch)
		
		# set position of target
		if target_node is Control:
			target_node.rect_position = target_position
		
		elif target_node is Node2D:
			target_node.position = target_position
