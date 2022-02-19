extends ButtonExpansionMenu


func _ready() -> void:
	nodes.build_here_button = find_node("BuildHereButton")
	nodes.build_here_button.connect(
			"pressed",
			self,
			"build_button_pressed"
	)
	
	nodes.open_button.connect(
			"pressed",
			self,
			"open_button_pressed"
	)
	
	nodes.close_button.connect(
			"pressed",
			self,
			"close_button_pressed"
	)


func build_button_pressed() -> void:
	States.Build.emit_signal("build_here_pressed")
	States.Build.set_to(States.Build.EDITING)
	
	.toggle()


func open_button_pressed() -> void:
	States.Build.set_to(States.Build.PLACING)
		

func close_button_pressed() -> void:
	States.Build.set_to(States.Build.READY)
