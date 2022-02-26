tool
extends EditorPlugin

const nodes := {
	share_resource = {
		script = preload("nodes/share_resource.gd"),
		icon = preload("icons/png/share_resource_icon.png"),
	},
	queue = {
		script = preload("nodes/queue.gd"),
		icon = preload("icons/png/queue_icon.png")
	},
	follow_viewport_child = {
		script = preload("nodes/follow_viewport_child.gd"),
		icon = preload("icons/png/follow_viewport_child_icon.png")
	},
	state = {
		script = preload("nodes/state.gd"),
		icon = preload("icons/png/state_icon.png")
	},
	save = {
		script = preload("nodes/save.gd"),
		icon = preload("icons/png/save_icon.png")
	},
	layered_texture_generator = {
		script = preload("nodes/layered_texture_generator.gd"),
		icon = preload("icons/png/layered_texture_generator_icon.png")
	}
}

func _enter_tree() -> void:
	add_custom_type("ShareResource", "Node", nodes.share_resource.script, nodes.share_resource.icon)
	add_custom_type("Queue", "Node", nodes.queue.script, nodes.queue.icon)
	add_custom_type("FollowViewportChild", "Node", nodes.follow_viewport_child.script, nodes.follow_viewport_child.icon)
	add_custom_type("State", "Node", nodes.state.script, nodes.state.icon)
	add_custom_type("Save", "Node", nodes.save.script, nodes.save.icon)
	add_custom_type("LayeredTextureGenerator", "ViewportContainer", nodes.layered_texture_generator.script, nodes.layered_texture_generator.icon)


func _exit_tree() -> void:
	remove_custom_type("ShareResource")
	remove_custom_type("Queue")
	remove_custom_type("FollowViewportChild")
	remove_custom_type("State")
	remove_custom_type("Save")
	remove_custom_type("LayeredTextureGenerator")
