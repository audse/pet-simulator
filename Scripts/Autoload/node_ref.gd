class_name NodeRef
extends Object

static func is_node_valid(node:Node, type=null) -> bool:
	""" is_node_valid (static)
		checks that node exists, is in the scene, and extends the correct type
		
		:param node: Node
		:param type: Type (optional)
			the base type/class that the node should extend, e.g. Node2D, Viewport, etc.
		:returns: bool
	"""
	if not (
		is_instance_valid(node)
		and node.is_inside_tree()
		and (node is type or type == null)
	): return false
	return true


static func get_node_position(node:Node) -> Vector2:
	""" get_node_position
		:param node: Node2D or Control
		:returns: Vector2
			returns the rect_position or position based on node
			class/type
	"""
	var position := Vector2.ZERO
	
	if is_node_valid(node, Node):
		if "rect_position" in node:
			position += (node as Control).rect_position
		elif "position" in node:
			position += (node as Node2D).position
	
	return position


static func set_node_position(node:Node, position:Vector2) -> void:
	""" set_node_position
	
		sets the rect_position or position based on node
		class/type
		
		:param node: Node2D or Control
		:param position: Vector2
	"""
	if is_node_valid(node, Node):
		if "rect_position" in node:
			(node as Control).rect_position = position
		elif "position" in node:
			(node as Node2D).position = position
