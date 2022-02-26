class_name ControlRef
extends Object

""" ControlRef
	
Contains a set of helpful functions when dealing with control nodes

"""

func set_mouse_filter_of_children(node:Node, filter:int, exclude:Array=[]) -> void:
	""" set_mouse_filter_of_children
		Recursively searches child nodes and sets the mouse filter
		
		:param node: Node
			parent node, sets self (inclusive) and children
		:param filter: int
			one of Control.MOUSE_FILTER
		:param exclude: Array<Node>
			a list of nodes to NOT set the mouse filter (but
			children of this node are still searched)
	"""
	if node is Control and not node in exclude:
		node.mouse_filter = filter
	for child in node.get_children():
		set_mouse_filter_of_children(child, filter)


static func is_within_control(point:Vector2, node:Control) -> bool:
	var node_rect:Rect2 = Rect2(node.rect_global_position, node.rect_size)
	return node_rect.has_point(point)
