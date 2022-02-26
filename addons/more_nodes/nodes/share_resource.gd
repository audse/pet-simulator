class_name ShareResource extends Node

""" ShareResource

Automatically populates & updates resource to all given nodes, corresponding
to a given property name.

Attributes:
	nodes (Array<NodePath>):
		the nodes that will be given the specified resource
	resource (Resource):
		the resource to be distributed
	property_name (String):
		the property name for the resource within the nodes. if there is only
		one element in the array, the same property name will be used for
		every node
	is_unique (bool):
		determines whether or not to duplicate resource when populating nodes
"""

## @nodes: the nodes that will be given the specified resource
export (Array, NodePath) var nodes setget set_nodes, get_nodes
## @resource: the resource to be distributed
export (Resource) var resource setget set_resource, get_resource
## @property_names: the property name for the resource within the nodes. if
## there is only one element in the array, the same property name will be used
## for every node
export (Array, String) var property_names
## @is_unique: determines whether or not to duplicate resource when populating 
## nodes
export (bool) var is_unique = false
export (bool) var logging_enabled = true

var node_list:Array = []

func _ready() -> void:
	self.nodes = nodes


func set_nodes(nodes_value:Array) -> void:
	nodes = nodes_value
	node_list = []
	
	if is_inside_tree():
		for node_path in nodes:
			node_list.append(get_node(node_path))
		
		if resource:
			self.resource = resource


func get_nodes() -> Array:
	return nodes


func set_resource(resource_value:Resource) -> void:
	resource = resource_value
	
	if logging_enabled:
		prints("\nSharing", resource, "...")
	
	var index := 0
	for node in node_list:
		if (
			is_node_valid(node)
			and len(property_names) > 0
			and resource
		):
			var property_name = (
				property_names[0] 
				if len(property_names) == 1 or index >= len(property_names)
				else property_names[index]
			)
			
			if logging_enabled:
				prints("\t...with", node)
				
			if not is_unique:
				node.set(property_name, resource)
			else:
				node.set(property_name, resource.duplicate())


func get_resource() -> Resource:
	return resource


func is_node_valid(node:Node) -> bool:
	return (
		node
		and is_instance_valid(node)
		and node.is_inside_tree()
	)
