extends Node

class ModeState extends State:
	enum {
		PLAY,
		BUILD,
		DESIGN,
		FURNISH
	}
	
	func _init(
			state_value:int, 
			reset_value=null
	).(state_value, reset_value) -> void:
		pass


class BuildState extends State:
	signal build_here_pressed
	signal build_door_pressed
	signal build_window_pressed

	enum {
		ZERO,
		READY,
		PLACING,
		EDITING,
		DEMOLISHING,
		CONFIRM_DEMOLISH
	}
	
	enum {
		WALL,
		DOOR,
		WINDOW
	}
	
	var Type:State = State.new(WALL)
	
	func _init(
			state_value:int, 
			reset_value=null
	).(state_value, reset_value) -> void:
		pass


class DesignState extends State:
	signal design_selected(type, tile_id, option)
	signal hide_roof
	signal show_roof
	
	
	enum {
		ZERO,
		READY,
		SELECTING
	}
	
	enum {
		EXTERIOR,
		FLOOR,
		INTERIOR,
		ROOF
	}
	
	var Selector:State = State.new(ROOF)
	
	func _init(
			state_value:int, 
			reset_value=null
	).(state_value, reset_value) -> void:
		pass


onready var Mode:ModeState = ModeState.new(ModeState.PLAY)
onready var Build:BuildState = BuildState.new(BuildState.ZERO)
onready var Design:DesignState = DesignState.new(DesignState.ZERO)
