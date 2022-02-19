class_name BuildingInputController
extends BuildingComponent

var renderer:BuildingInputRenderer

func _init(
	data_value:BuildingData,
	input_value:BuildingInput,
	tile_manager:BuildingTileManager
).(data_value, input_value, tile_manager) -> void:
	
	renderer = BuildingInputRenderer.new(
		data_value,
		input_value,
		tile_manager
	)


func _ready() -> void:
	add_child(renderer)
	
	_connect = States.Build.connect("enter_state", self, "enter_state")
	_connect = States.Build.connect("exit_state", self, "exit_state")
	
	_connect = renderer.connect("handle_drag_released", self, "_handle_drag_released")
	
#	yield(Timers.wait(3), "completed")
#	renderer.queue_start()
	
#	Test data
#	var new_handle = GuideMapHandle.new(
#		tile_manager.base_map,
#		{}
#	)
#
#	add_child(new_handle)
#	yield(Timers.wait(4), "completed")
#	_handle_drag_released(Vector2(9, 14), Vector2(9, 10), new_handle)
#	print("release")


func enter_state(next_state:int) -> void:
	match next_state:
		States.Build.ZERO:
			pass
		States.Build.READY:
			pass
		States.Build.EDITING:
			if States.Build.target_node == input.target_node:
				renderer.queue_start()
			
		States.Build.DEMOLISHING:
			pass
		States.Build.CONFIRM_DEMOLISH:
			if States.Build.target_node == input.target_node:
				""" first, destroy the marker buttons, THEN emit this signal """
				input.emit_signal("input_destroyed")


func exit_state(prev_state:int) -> void:
	match prev_state:
		States.Build.ZERO:
			pass
		States.Build.READY:
			pass
		States.Build.EDITING:
			if States.Build.target_node == input.target_node:
				renderer.queue_stop()
			
		States.Build.DEMOLISHING:
			pass
		States.Build.CONFIRM_DEMOLISH:
			pass


func _handle_drag_released(from_coord:Vector2, to_coord:Vector2, handle:Handle) -> void:
	renderer.queue_pause()
	
	var is_setting:bool = false
	
	# Get cells to set from regular handles
	if not handle is ArrowGuideMapHandle:
		
		var cells_to_set:Dictionary = tile_manager.get_cells_to_set(from_coord, to_coord)
		if cells_to_set.has_all(["cells", "action"]):
			is_setting = true
			
			match cells_to_set.action:
				tile_manager.Action.SET_CELLS:
					input.emit_signal("set_cells", cells_to_set.cells)
				tile_manager.Action.ERASE_CELLS:
					input.emit_signal("erase_cells", cells_to_set.cells)
	
	# Get cells to set from arrow handles
	elif handle is ArrowGuideMapHandle:
		
		var direction:int = handle.direction
		var num_additions:int = handle.get_num_cells_passed(from_coord, to_coord)
		
		if num_additions != 0:
			input.emit_signal("add_to_direction", direction, num_additions)
			is_setting = true
	
	# yield only if there will be an animation
	if is_setting and tile_manager.base_map:
		yield(tile_manager, "slide_finished")
	
	renderer.queue_unpause()
