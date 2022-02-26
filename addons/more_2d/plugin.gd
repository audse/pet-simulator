tool
extends EditorPlugin

const icons := {
	drag = preload("icons/png/drag_icon.png"),
	draggable = preload("icons/png/draggable_icon.png"),
	handle = preload("icons/png/handle_icon.png"),
	arrow_guide_map_handle = preload("icons/png/arrow_guide_map_handle_icon.png"),
	guide_map_handle = preload("icons/png/guide_map_handle_icon.png")
}

func _enter_tree() -> void:
	add_custom_type("Drag", "Node2D", preload("nodes/drag/drag.gd"), icons.drag)
	add_custom_type("Draggable", "Node2D", preload("nodes/drag/draggable.gd"), icons.draggable)
	add_custom_type("Handle", "Node2D", preload("nodes/drag/handles/handle.gd"), icons.handle)
	add_custom_type("HandleGroup", "Node2D", preload("nodes/drag/handles/handle.gd"), icons.handle)
	add_custom_type("GuideMapHandle", "Node2D", preload("nodes/drag/handles/guide_map_handle.gd"), icons.guide_map_handle)
	add_custom_type("GuideMapHandleGroup", "Node2D", preload("nodes/drag/handles/guide_map_handle_group.gd"), icons.guide_map_handle)
	add_custom_type("ArrowGuideMapHandle", "Node2D", preload("nodes/drag/handles/arrow_guide_map_handle.gd"), icons.arrow_guide_map_handle)
	add_custom_type("ArrowGuideMapHandleGroup", "Node2D", preload("nodes/drag/handles/arrow_guide_map_handle_group.gd"), icons.arrow_guide_map_handle)


func _exit_tree() -> void:
	remove_custom_type("Drag")
	remove_custom_type("Draggable")
	remove_custom_type("Handle")
	remove_custom_type("GuideMapHandle")
	remove_custom_type("GuideMapHandleGroup")
	remove_custom_type("ArrowGuideMapHandle")
	remove_custom_type("ArrowGuideMapHandleGroup")
