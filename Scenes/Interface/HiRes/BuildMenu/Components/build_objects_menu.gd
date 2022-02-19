extends ButtonExpansionMenu

var _connect

enum {
	MENU,
	PLACING
}

var menu_buttons_group:PopButtonGroup = PopButtonGroup.new()
var placing_buttons_group:PopButtonGroup = PopButtonGroup.new()

func _ready() -> void:
	# set up buttons
	nodes.door_button = find_node("DoorButton")
	nodes.window_button = find_node("WindowButton")
	nodes.place_here_button = find_node("PlaceHereButton")
	
	# set up button groups
	menu_buttons_group.setup([nodes.door_button, nodes.window_button])
	placing_buttons_group.hide_on_start = true
	placing_buttons_group.setup([nodes.place_here_button])
	
	# set up connections
	_connect = nodes.door_button.connect("pressed", States.Build.Type, "set_to", [States.Build.DOOR])
	_connect = nodes.window_button.connect("pressed", States.Build.Type, "set_to", [States.Build.WINDOW])
	_connect = nodes.place_here_button.connect("pressed", self, "_on_place_here_pressed")
	
	_connect = States.Build.Type.connect("enter_state", self, "enter_build_type_state")


func enter_build_type_state(next_state:int) -> void:
	match next_state:
		States.Build.WALL:
			toggle_buttons(MENU)
		States.Build.DOOR:
			toggle_buttons(PLACING)
		States.Build.WINDOW:
			toggle_buttons(PLACING)


func toggle_buttons(state:int) -> void:
	match state:
		MENU:
			yield(placing_buttons_group.queue_exit(), "completed")
			menu_buttons_group.queue_enter()
		PLACING:
			yield(menu_buttons_group.queue_exit(), "completed")
			placing_buttons_group.queue_enter()


func _on_place_here_pressed() -> void:
	match States.Build.Type.state:
		States.Build.WALL:
			pass
		
		States.Build.DOOR:
			States.Build.emit_signal("build_door_pressed")
			States.Build.Type.set_to(States.Build.WALL)
			
		States.Build.WINDOW:
			States.Build.emit_signal("build_window_pressed")
			States.Build.Type.set_to(States.Build.WALL)
