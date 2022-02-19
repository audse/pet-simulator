extends Node2D

var parent_to_viewport_node:ParentToViewportNode

func _ready() -> void:
	var scene = get_tree().current_scene
	parent_to_viewport_node = ParentToViewportNode.new(
			self,
			scene.find_node("Main"),
			scene.find_node("MainViewport")
	)
	add_child(parent_to_viewport_node)
