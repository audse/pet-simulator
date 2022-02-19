class_name BuildingInputRenderer
extends BuildingComponent

signal handle_drag_released(from_coord, to_coord, handle)


var queue = Queue.new()
var nodes:Dictionary = {
	handles = null,
	arrow_handles = null
}


func _init(
	data_value:BuildingData,
	input_value:BuildingInput,
	tile_manager:BuildingTileManager
).(data_value, input_value, tile_manager) -> void:
	pass


func _ready() -> void:
	queue.setup(self, true)
	
	_connect = tile_manager.connect("base_map_changed", self, "_base_map_changed")
	
	# create handle groups
	nodes.handles = GuideMapHandleGroup.new(
		tile_manager.base_map,
		true
	)
	nodes.arrow_handles = ArrowGuideMapHandleGroup.new(
		tile_manager.base_map,
		true
	)
	add_child(nodes.handles)
	add_child(nodes.arrow_handles)
	
	# make connections
	nodes.handles.connect("handle_drag_released", self, "_handle_drag_released")
	nodes.arrow_handles.connect("handle_drag_released", self, "_handle_drag_released")


func queue_start() -> void:
	queue.add_func("start", [], true)


func start() -> void:
	nodes.handles.z_index = 10
	nodes.arrow_handles.z_index = 10
	nodes.handles.draw_from_base_map(tile_manager.autotile_coords.undraggable, { sprite_offset = Vector2(6, 12) })
	yield(nodes.arrow_handles.draw(), "completed")


func queue_pause() -> void:
	queue.add_func("pause", [], true)


func pause() -> void:
	nodes.handles.delete_all()
	yield(nodes.arrow_handles.disable_all(), "completed")


func queue_unpause() -> void:
	queue.add_func("unpause", [], true)


func unpause() -> void:
	nodes.handles.draw_from_base_map(tile_manager.autotile_coords.undraggable)
	nodes.arrow_handles.update_positions()
	yield(nodes.arrow_handles.enable_all(), "completed")


func queue_stop() -> void:
	queue.add_func("stop", [], true)


func stop() -> void:
	nodes.handles.delete_all()
	yield(nodes.arrow_handles.delete_all(), "completed")


#func draw_placement_guide(guide_position:Vector2=Vector2.ZERO) -> void:
#	pass
#
#
#func draw_marker_button(marker_button:PopButton) -> void:
#	pass
#
#
#func toggle_marker_button(marker_button:PopButton) -> void:
#	pass


func _handle_drag_released(from_coord:Vector2, to_coord:Vector2, handle:Handle) -> void:
	emit_signal("handle_drag_released", from_coord, to_coord, handle)


func _base_map_changed() -> void:
	nodes.handles.base_map = tile_manager.base_map
	nodes.arrow_handles.base_map = tile_manager.base_map
