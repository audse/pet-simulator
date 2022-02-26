tool
extends EditorPlugin

const scripts := {
	column_container = preload("nodes/containers/column_container.gd"),
	circle_container = preload("nodes/containers/circle_container.gd"),
	process_viewport_container = preload("nodes/containers/process_viewport_container.gd"),
	modal = preload("nodes/modal.gd"),
}

const icons := {
	column_container = preload("icons/png/column_container_icon.png"),
	circle_container = preload("icons/png/circle_container_icon.png"),
	process_viewport_container = preload("icons/png/process_viewport_container_icon.png"),
	modal = preload("icons/png/modal_icon.png")
}


func _enter_tree() -> void:
	add_custom_type("ColumnContainer", "Container", scripts.column_container, icons.column_container)
	add_custom_type("CircleContainer", "Container", scripts.circle_container, icons.circle_container)
	add_custom_type("ProcessViewportContainer", "ViewportContainer", scripts.process_viewport_container, icons.process_viewport_container)
	add_custom_type("Modal", "Control", scripts.modal, icons.modal)


func _exit_tree() -> void:
	remove_custom_type("ColumnContainer")
	remove_custom_type("CircleContainer")
	remove_custom_type("ProcessViewportContainer")
	remove_custom_type("Modal")
