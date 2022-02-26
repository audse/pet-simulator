class_name BuildingInputController
extends BuildingComponent

onready var parent := get_parent()
onready var renderer:BuildingInputRenderer = $InputRenderer

func _ready() -> void:
	_connect = States.Build.connect("enter_state", self, "enter_state")
	_connect = States.Build.connect("exit_state", self, "exit_state")
	
	_connect = renderer.connect("handle_drag_released", self, "_handle_drag_released")
	_connect = renderer.get_node("MarkerButton").connect("pressed", self, "building_selected")


func enter_state(next_state:int) -> void:
	if data:
		match next_state:
			States.Build.ZERO:
				pass
			States.Build.READY:
				renderer.draw_marker_button()
			
			States.Build.EDITING:
				if States.Build.target_node == parent:
					renderer.queue_start()
				
			States.Build.DEMOLISHING:
				pass
			States.Build.CONFIRM_DEMOLISH:
				if States.Build.target_node == parent:
					""" first, destroy the marker buttons, THEN emit this signal """
					data.input.emit_signal("input_destroyed")


func exit_state(prev_state:int) -> void:
	if data:
		match prev_state:
			States.Build.ZERO:
				pass
			States.Build.READY:
				renderer.exit_marker_button()
			
			States.Build.EDITING:
				if States.Build.target_node == parent:
					renderer.queue_stop()
				
			States.Build.DEMOLISHING:
				pass
			States.Build.CONFIRM_DEMOLISH:
				pass


func building_selected() -> void:
	States.Build.target_node = parent
	States.Build.set_to(States.Build.EDITING)


func _handle_drag_released(from_coord:Vector2, to_coord:Vector2, handle:Handle) -> void:
	if data:
		renderer.queue_pause()
		
		var is_setting:bool = false
		
		# Get cells to set from regular handles
		if not handle is ArrowGuideMapHandle:
			
			var cells_to_set:Dictionary = data.tile_manager.get_cells_to_set(from_coord, to_coord)
			if cells_to_set.has_all(["cells", "action"]):
				is_setting = true
				
				match cells_to_set.action:
					data.tile_manager.Action.SET_CELLS:
						data.input.emit_signal("set_cells", cells_to_set.cells)
					data.tile_manager.Action.ERASE_CELLS:
						data.input.emit_signal("erase_cells", cells_to_set.cells)
		
		# Get cells to set from arrow handles
		elif handle is ArrowGuideMapHandle:
			
			var direction:int = (handle as ArrowGuideMapHandle).direction
			var num_additions:int = (handle as ArrowGuideMapHandle).get_num_cells_passed(from_coord, to_coord)
			
			if num_additions != 0:
				data.input.emit_signal("add_to_direction", direction, num_additions)
				is_setting = true
		
		# yield only if there will be an animation
		if is_setting and data.tile_manager.base_map:
			yield(data.tile_manager, "slide_finished")
		
		renderer.queue_unpause()
