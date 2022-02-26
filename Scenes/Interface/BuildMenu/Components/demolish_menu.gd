extends ButtonExpansionMenu

func _ready() -> void:
	nodes.finish_button = find_node("FinishedDemolishingButton")
	
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
	nodes.finish_button.connect(
			"pressed",
			self,
			"finish_button_pressed"
	)


func open_button_pressed() -> void:
	States.Build.set_to(States.Build.DEMOLISHING)


func close_button_pressed() -> void:
	States.Build.set_to(States.Build.READY)


func finish_button_pressed() -> void:
	States.Build.set_to(States.Build.READY)
	.toggle()
