class_name BuildingInputRenderer
extends BuildingComponent

signal handle_drag_released(from_coord, to_coord, handle)

onready var queue := $Queue as Queue

onready var handles := $GuideMapHandleGroup as GuideMapHandleGroup
onready var arrow_handles := $ArrowGuideMapHandleGroup as ArrowGuideMapHandleGroup
onready var marker_button := $MarkerButton as BaseButton
onready var marker_pencil_icon := $MarkerButton/PencilIcon as Sprite
onready var marker_x_icon := $MarkerButton/XIcon as Sprite


func _ready() -> void:
	# make connections
	_connect = handles.connect("handle_drag_released", self, "_handle_drag_released")
	_connect = arrow_handles.connect("handle_drag_released", self, "_handle_drag_released")


func queue_start() -> void:
	queue.add_func("start", [], true)


func start() -> void:
	handles.draw_from_base_map(data.tile_manager.autotile_coords.undraggable, { sprite_offset = Vector2(6, 12) })
	yield(arrow_handles.draw(), "completed")


func queue_pause() -> void:
	queue.add_func("pause", [], true)


func pause() -> void:
	handles.delete_all()
	yield(arrow_handles.disable_all(), "completed")


func queue_unpause() -> void:
	queue.add_func("unpause", [], true)


func unpause() -> void:
	handles.draw_from_base_map(data.tile_manager.autotile_coords.undraggable)
	arrow_handles.update_positions()
	yield(arrow_handles.enable_all(), "completed")


func queue_stop() -> void:
	queue.add_func("stop", [], true)


func stop() -> void:
	handles.delete_all()
	yield(arrow_handles.delete_all(), "completed")


#func draw_placement_guide(guide_position:Vector2=Vector2.ZERO) -> void:
#	pass
#
#

func draw_marker_button(is_demolishing:bool=false) -> void:
	var midpoint_position := data.tile_manager.base_map.get_midpoint_position()
	var texture_midpoint := (marker_button as TextureButton).texture_normal.get_size() / 2
	marker_button.rect_position = midpoint_position - texture_midpoint
	marker_button.rect_position.y -= texture_midpoint.y
	
	if is_demolishing:
		marker_pencil_icon.visible = false
		marker_x_icon.visible = true
		(marker_button as PopButton).queue_activate()
	else:
		marker_pencil_icon.visible = true
		marker_x_icon.visible = false
	
	(marker_button as PopButton).queue_enter()
	
	yield(Timers.wait(0.5), "completed")
	
	print("button entered", marker_button.rect_position)


func exit_marker_button() -> void:
	(marker_button as PopButton).queue_exit()
	(marker_button as PopButton).queue_activate()


func toggle_marker_button(is_demolishing:bool=false) -> void:
	if is_demolishing:
		(marker_button as PopButton).queue_exit()
		(marker_button as PopButton).queue_deactivate()
		(marker_button as PopButton).queue_enter()
		marker_pencil_icon.visible = true
		marker_x_icon.visible = false
	else:
		(marker_button as PopButton).queue_exit()
		(marker_button as PopButton).queue_activate()
		(marker_button as PopButton).queue_enter()
		yield(Timers.wait(0.5), "completed")
		marker_pencil_icon.visible = true
		marker_x_icon.visible = false


func _handle_drag_released(from_coord:Vector2, to_coord:Vector2, handle:Handle) -> void:
	emit_signal("handle_drag_released", from_coord, to_coord, handle)


func _base_map_changed() -> void:
	handles.base_map = data.tile_manager.base_map
	arrow_handles.base_map = data.tile_manager.base_map


func set_data(data_value:BuildingData) -> void:
	.set_data(data_value)
	_connect = data.tile_manager.connect("base_map_changed", self, "_base_map_changed")
	_base_map_changed()
